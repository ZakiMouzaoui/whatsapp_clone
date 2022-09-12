import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';

class Status{
  final String statusId;
  final String uid;
  final String userName;
  final String profilePic;
  final StatusEnum statusType;
  final String statusContent;
  final DateTime createdAt;
  final List<dynamic> seenBy;

  Status({
    required this.statusId,
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.statusType,
    required this.statusContent,
    required this.createdAt,
    required this.seenBy,
  });

  Map<String, dynamic> toJson(){
    return {
      "statusId": statusId,
      "uid": uid,
      "userName": userName,
      "profilePic": profilePic,
      "statusType": statusType.type,
      "statusContent": statusContent,
      "createdAt": createdAt,
      "seenBy": seenBy
    };
  }

  static Status fromJson(Map<String, dynamic> json){
    return Status(
        statusId: json["statusId"],
        uid: json["uid"],
        userName: json["userName"],
        profilePic: json["profilePic"],
        statusType: (json["statusType"] as String).toEnum(),
        statusContent: json["statusContent"],
        createdAt: (json["createdAt"] as Timestamp).toDate(),
        seenBy: json["seenBy"]
    );
  }
}
