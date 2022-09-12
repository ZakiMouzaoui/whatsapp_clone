import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/status_contact.dart';
import 'package:whatsapp_clone/models/user_model.dart';


final statusRepositoryProvider = Provider((ref) =>
    StatusRepository(fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance)
);

class StatusRepository{
  StatusRepository({required this.fireStore, required this.auth});

  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  void addTextStatus(String text)async{
    final String statusId = const Uuid().v1();
    final uid = auth.currentUser!.uid;
    final userRef = fireStore.collection("users").doc(uid);
    final userDoc = await userRef.get();
    final userModel = UserModel.fromJson(userDoc.data()!);

    final statusModel = Status(
        statusId: statusId,
        uid: auth.currentUser!.uid,
        userName: userModel.name,
        profilePic: userModel.profilePic,
        statusType: StatusEnum.text,
        statusContent: text,
        createdAt: DateTime.now(),
        seenBy: []
    );

    await userRef
        .collection("status")
        .doc(statusId)
        .set(statusModel.toJson());
  }

  Future<List<StatusContact>> getStatus()async{
    List<StatusContact> statusContacts = [];

    try{
      var statusSnapshots = await fireStore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("status")
          .where("createdAt", isGreaterThan: DateTime.now().subtract(24.hours))
          .get();

      List<Status> statuses = [];
      for(final doc in statusSnapshots.docs){
        Status status = Status.fromJson(doc.data());
        statuses.add(status);

      }
      print(statuses.length);
      statusContacts.add(StatusContact(statuses: statuses));
    }

    catch(e){
      printError(info: e.toString());
    }

    return statusContacts;
  }
}
