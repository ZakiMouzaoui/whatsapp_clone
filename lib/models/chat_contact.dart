import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.lastMessage,
      required this.timeSent});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profilePic": profilePic,
      "contactId": contactId,
      "lastMessage": lastMessage,
      "timeSent": timeSent
    };
  }

  static ChatContact fromJson(Map<String, dynamic> json){
    return ChatContact(
        name: json["name"],
        profilePic: json["profilePic"],
        contactId: json["contactId"],
        lastMessage: json["lastMessage"],
        timeSent: (json["timeSent"] as Timestamp).toDate()
    );
  }
}
