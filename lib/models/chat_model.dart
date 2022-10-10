import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String name;
  final String? phoneNumber;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  final String type;

  ChatModel(
      {required this.name,
      required this.profilePic,
      required this.phoneNumber,
      required this.contactId,
      required this.lastMessage,
      required this.timeSent,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profilePic": profilePic,
      'phoneNumber': phoneNumber,
      "contactId": contactId,
      "lastMessage": lastMessage,
      "timeSent": timeSent,
      "type": type
    };
  }

  static ChatModel fromJson(Map<String, dynamic> json) {
    return ChatModel(
        name: json["name"],
        profilePic: json["profilePic"],
        phoneNumber: json["phoneNumber"],
        contactId: json["contactId"],
        lastMessage: json["lastMessage"],
        timeSent: (json["timeSent"] as Timestamp).toDate(),
        type: json["type"]);
  }
}
