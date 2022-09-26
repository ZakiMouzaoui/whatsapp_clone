import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/models/status.dart';

class StatusContact{
  List<Status> statuses;
  final DateTime lastStatusTime;
  final String uid;
  final String userName;
  final String profilePic;
  List<dynamic> completedBy;

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "lastStatusTime": lastStatusTime,
      "statuses": statuses
    };
  }

  static StatusContact fromJson(Map<String, dynamic> json){
    return StatusContact(
        lastStatusTime: (json["lastStatusTime"] as Timestamp).toDate(),
        uid: json["uid"],
        userName: json["userName"],
        profilePic: json["profilePic"],
        statuses: [],
        completedBy: json["completedBy"]
    );
  }

  StatusContact({
    required this.statuses,
    required this.lastStatusTime,
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.completedBy,
  });
}
