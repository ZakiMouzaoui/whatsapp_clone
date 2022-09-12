import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';

class Message{
  String senderId;
  String receiverId;
  String text;
  final MessageEnum messageType;
  DateTime timeSent;
  String messageId;
  bool isSeen;
  int? diff;
  final String repliedTo;
  final String repliedMessage;
  final MessageEnum repliedMessageType;

  Message({required this.senderId, required this.receiverId, required this.text, required this.messageType,
  required this.timeSent, required this.messageId, required this.isSeen,
    required this.repliedTo, required this.repliedMessage, required this.repliedMessageType, });

  Map<String, dynamic> toJson(){
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "messageType": messageType.type,
      "timeSent": timeSent,
      "messageId": messageId,
      "isSeen": isSeen,
      "repliedTo": repliedTo,
      "repliedMessage": repliedMessage,
      "repliedMessageType": repliedMessageType.type
    };
  }

  static Message fromJson(Map<String, dynamic> json){
    return Message(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        text: json["text"],
        messageType: (json["messageType"] as String).toEnum(),
        timeSent: (json["timeSent"] as Timestamp).toDate(),
        messageId: json["messageId"],
        isSeen: json["isSeen"],
        repliedTo: json["repliedTo"] ?? "",
        repliedMessage: json["repliedMessage"] ?? "",
        repliedMessageType: json["repliedMessageType"] != null ? (json["repliedMessageType"] as String).toEnum() : MessageEnum.text
    );
  }
}
