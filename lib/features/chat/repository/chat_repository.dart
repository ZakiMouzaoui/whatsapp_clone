import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  ChatRepository({required this.fireStore, required this.auth});

  void _saveDataToContactSubCollection(UserModel senderUserData,
      UserModel receiverUserData, String message, DateTime sentTime) async {
    // FOR THE RECEIVER
    var receiverChatContact = ChatModel(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        phoneNumber: senderUserData.phoneNumber,
        lastMessage: message,
        timeSent: sentTime,
        type: "contact"
    );
    await fireStore
        .collection("users")
        .doc(receiverUserData.uid)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toJson());

    // FOR THE SENDER
    var senderChatContact = ChatModel(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        phoneNumber: receiverUserData.phoneNumber,
        contactId: receiverUserData.uid,
        lastMessage: message,
        timeSent: sentTime,
        type: "contact"
    );
    await fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserData.uid)
        .set(senderChatContact.toJson());
  }

  void _saveMessageToMessageSubCollection(
      String receiverUid,
      String text,
      DateTime timeSent,
      String messageId,
      String senderName,
      String receiverName,
      MessageEnum messageType,
      MessageReply? messageReply) async {

    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUid,
      text: text,
      timeSent: timeSent,
      isSeen: false,
      messageType: messageType,
      messageId: messageId,
      repliedTo: messageReply != null ? messageReply.repliedUserName : "",
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageType,
      deleted: false
    );

    await fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUid)
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());

    await fireStore
        .collection("users")
        .doc(receiverUid)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required receiverUID,
    required UserModel senderUser,
    MessageReply? messageReply
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserModel;
      final receiverDoc =
          await fireStore.collection("users").doc(receiverUID).get();
      receiverUserModel = UserModel.fromJson(receiverDoc.data()!);

      _saveDataToContactSubCollection(
          senderUser, receiverUserModel, message, timeSent);

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(receiverUID, message, timeSent,
          messageId, senderUser.name, receiverUserModel.name, MessageEnum.text, messageReply);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required receiverUID,
    required UserModel senderUser,
    required ProviderRef ref,
    required MessageEnum messageType,
    MessageReply? messageReply,
  })async{
    try{
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      UserModel receiverUserModel;

      final receiverDoc = await fireStore.collection("users").doc(receiverUID).get();
      receiverUserModel = UserModel.fromJson(receiverDoc.data()!);

      final fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("chats/${messageType.type}/${senderUser.uid}/$receiverUID/$messageId", file);

      String contactMessage = "";
      switch(messageType.type){
        case "image":
          contactMessage = "📷 Photo";
          break;
        case "audio":
          contactMessage = "🎵 Audio";
          break;
        case "video":
          contactMessage = "🎬 Video";
          break;
        case "gif":
          contactMessage = "GIF";
          break;
      }

      _saveDataToContactSubCollection(
          senderUser, receiverUserModel, contactMessage, timeSent);

      _saveMessageToMessageSubCollection(receiverUID, fileUrl, timeSent,
          messageId, senderUser.name, receiverUserModel.name, messageType, messageReply);
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifURL,
    required receiverUID,
    required UserModel senderUser,
    MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserModel;
      final receiverDoc =
      await fireStore.collection("users").doc(receiverUID).get();
      receiverUserModel = UserModel.fromJson(receiverDoc.data()!);

      _saveDataToContactSubCollection(
          senderUser, receiverUserModel, "Gif", timeSent);

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(receiverUID, gifURL, timeSent,
          messageId, senderUser.name, receiverUserModel.name, MessageEnum.gif, messageReply);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<ChatModel?>>? getChats() {
    try{
      return fireStore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .orderBy("timeSent", descending: true)
          .snapshots()
          .asyncMap((event) async {
        List<ChatModel?> chatContacts = [];
        for (var doc in event.docs) {
          ChatModel contact = ChatModel.fromJson(doc.data());
          chatContacts.add(contact);
        }
        return chatContacts;
      });
    }
    catch(e){
      printError(info: e.toString());
      return null;
    }

  }

  Stream<List<Message>> getChatMessages(String receiverId){
    return fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .asyncMap((event){
          List<Message> messages = [];
          final diffs = [];
          for(var doc in event.docs){
            final message = Message.fromJson(doc.data());
            int diff = DateTime.now().difference(message.timeSent).inDays;
            if(!diffs.contains(diff)){
              message.diff = diff;
              diffs.add(diff);
            }
            messages.add(message);

            if(doc.get("receiverId") == auth.currentUser!.uid){
              if(doc.get("isSeen") == false){
                updateMessageStatus(doc.get("messageId"), receiverId);
              }
            }
          }
          return messages;
    });
  }

  void updateMessageStatus(String messageId, String receiverId)async{
    await fireStore
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .update({
      'isSeen': true
    });
  }
  
  void deleteChatMessages(List<String> messagesIds, String chatId)async{
    final messagesCollection = await fireStore.collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("messageId", whereIn: messagesIds)
        .get();

    for (final messageDoc in messagesCollection.docs){
      await messageDoc.reference.delete();
    }
  }
}

