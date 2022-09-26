import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';

class Status{
  final String statusId;
  final StatusEnum statusType;
  final String statusContent;
  final String caption;
  final List<dynamic> seenBy;
  final String? backgroundColor;
  final DateTime createdAt;

  Status({
    required this.statusId,
    required this.statusType,
    required this.statusContent,
    this.caption="",
    required this.seenBy,
    this.backgroundColor,
    required this.createdAt,
  });

  Map<String, dynamic> toJson(){
    return {
      "statusId": statusId,
      "statusType": statusType.type,
      "backgroundColor": backgroundColor,
      "statusContent": statusContent,
      "caption": caption,
      "seenBy": seenBy,
      "createdAt": createdAt,
    };
  }

  static Status fromJson(Map<String, dynamic> json){
    return Status(
        statusId: json["statusId"],
        statusType: (json["statusType"] as String).toEnum(),
        backgroundColor: json["backgroundColor"],
        statusContent: json["statusContent"],
        caption: json["caption"],
        seenBy: json["seenBy"],
        createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }
}
