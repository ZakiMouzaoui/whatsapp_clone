import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/group_model.dart';
import 'package:whatsapp_clone/models/message.dart';

class GroupRepository extends GetxService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future addGroup(String name, File groupPic, List<Contact> members) async {
    try {
      final groupId = const Uuid().v1();
      final uid = auth.currentUser!.uid;
      final String adminId = uid;
      List<String> membersIds = [];
      List<String> numbers = [auth.currentUser!.phoneNumber!];

      for (final contact in members) {
        numbers.add(contact.phones[0].normalizedNumber.replaceAll(" ", ""));
      }
      final userCollection = await fireStore
          .collection("users")
          .where("phoneNumber", whereIn: numbers)
          .get();

      for (final userDoc in userCollection.docs) {
        membersIds.add(userDoc.id);
      }

      final picUrl =
          await storeFileToFirebase("groups/$groupId/$uid", groupPic);
      final message = "Welcome to group $name, you can start chatting";

      final group = GroupModel(
          groupId: groupId,
          name: name,
          groupPic: picUrl,
          adminId: adminId,
          members: membersIds,
          createdAt: DateTime.now(),
          lastMessage: message);

      await fireStore.collection("groups").doc(groupId).set(group.toJson());
      sendTextMessage(message: message, groupId: groupId);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void sendTextMessage(
      {required String message,
      required groupId,
      MessageReply? messageReply}) async {
    try {
      var timeSent = DateTime.now();
      final groupDoc = await fireStore.collection("groups").doc(groupId).get();

      _saveDataToChatSubCollection(groupDoc, message, timeSent);

      // saving the message for each member
      var messageId = const Uuid().v1();

      _saveMessageToMessageSubCollection(groupDoc, message, timeSent, messageId,
          groupDoc.get("name"), MessageEnum.text, messageReply);
    } catch (e) {
      // TODO
    }
  }

  void _saveDataToChatSubCollection(
      DocumentSnapshot groupDoc, String message, DateTime timeSent) async {
    var groupChat = ChatModel(
        name: groupDoc.get("name"),
        profilePic: groupDoc.get("groupPic"),
        phoneNumber: null,
        contactId: groupDoc.id,
        lastMessage: message,
        timeSent: timeSent,
        type: "group");

    for (final member in groupDoc.get("members")) {
      // we create a chat group model for each member
      await fireStore
          .collection("users")
          .doc(member)
          .collection("chats")
          .doc(groupDoc.id)
          .set(groupChat.toJson());
    }
  }

  void _saveMessageToMessageSubCollection(
      DocumentSnapshot groupDoc,
      String text,
      DateTime timeSent,
      String messageId,
      String receiverName,
      MessageEnum messageType,
      MessageReply? messageReply) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: groupDoc.get("groupId"),
        text: text,
        timeSent: timeSent,
        isSeen: false,
        messageType: messageType,
        messageId: messageId,
        repliedTo: messageReply != null ? messageReply.repliedUserName : "",
        repliedMessage: messageReply == null ? "" : messageReply.message,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageType,
        deleted: false);

    for (final member in groupDoc.get("members")) {
      await fireStore
          .collection("users")
          .doc(member)
          .collection("chats")
          .doc(groupDoc.id)
          .collection("messages")
          .doc(messageId)
          .set(message.toJson());
    }
  }
}
