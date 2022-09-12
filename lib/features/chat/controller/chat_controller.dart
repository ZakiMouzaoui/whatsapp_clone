import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController{
  final ProviderRef ref;
  final ChatRepository chatRepository;

  ChatController({required this.chatRepository, required this.ref, });


  void sendTextMessage(BuildContext context, String message, String receiverUid){
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userProvider).whenData((value) => chatRepository.sendTextMessage(
        context: context,
        message: message,
        receiverUID: receiverUid,
        senderUser: value!,
        messageReply: messageReply
    ));
  }

  void sendFileMessage(BuildContext context, File file, receiverUID, MessageEnum messageType){
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userProvider).whenData((value) => chatRepository.sendFileMessage(
        context: context,
        file: file,
        receiverUID: receiverUID,
        senderUser: value!,
        ref: ref,
        messageType: messageType,
        messageReply: messageReply
    ));
  }

  void sendGIFMessage(BuildContext context, String gifURL, String receiverUid){
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userProvider).whenData((value) => chatRepository.sendGIFMessage(
        context: context,
        receiverUID: receiverUid,
        senderUser: value!,
        gifURL: gifURL,
        messageReply: messageReply
    ));
  }

  Stream<List<ChatContact?>>? getChatContacts(){
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatMessages(String receiverId){
    return chatRepository.getChatMessages(receiverId);
  }

  void navigateToChatScreen(BuildContext context, ChatContact contact)async{
    final userData = await chatRepository.fireStore.collection("users").doc(contact.contactId).get();
    UserModel userModel = UserModel.fromJson(userData.data()!);
    Navigator.pushNamed(context, '/chat', arguments: userModel);
  }
}
