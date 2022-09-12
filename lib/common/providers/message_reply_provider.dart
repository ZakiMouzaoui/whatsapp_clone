import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';

class MessageReply{
  final String message;
  final bool isMe;
  final String repliedUserName;
  final MessageEnum messageType;

  MessageReply({required this.message, required this.isMe, required this.messageType, required this.repliedUserName, });

  void cancelReply(WidgetRef ref){
    ref.read(messageReplyProvider.state).update((state) => null);
  }
}

final messageReplyProvider = StateProvider<MessageReply?>((ref)=>null);
