import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class StatusRepository {
  StatusRepository({required this.fireStore, required this.auth});

  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  void addTextStatus(String text, String backgroundColor) async {
    try{
      final String statusId = const Uuid().v1();
      final uid = auth.currentUser!.uid;
      final userRef = fireStore.collection("users").doc(uid);
      final userDoc = await userRef.get();
      final userModel = UserModel.fromJson(userDoc.data()!);

      final statusModel = Status(
          statusId: statusId,
          statusType: StatusEnum.text,
          statusContent: text,
          backgroundColor: backgroundColor,
          seenBy: [],
          createdAt: DateTime.now(),
          );

      await fireStore.collection("statusContacts").doc(uid).set(
            {
              "uid": uid,
              "userName": userModel.name,
              "profilePic": userModel.profilePic,
              "lastStatusTime": statusModel.createdAt,
              "completedBy": [auth.currentUser!.uid]
            }
        );
        await fireStore
            .collection("statusContacts")
            .doc(uid)
            .collection("statuses")
            .doc(statusId)
            .set(statusModel.toJson());


      //await userRef.collection("status").doc(statusId).set(statusModel.toJson());
    }
    catch(e){
      printError(info: e.toString());
    }
  }

  Future addFileStatus(File file, StatusEnum statusType, ProviderRef ref, String caption) async {
    try{
      final String statusId = const Uuid().v1();
      final uid = auth.currentUser!.uid;
      final userRef = fireStore.collection("users").doc(uid);
      final userDoc = await userRef.get();
      final userModel = UserModel.fromJson(userDoc.data()!);

      final fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("statuses/${statusType.type}/$uid/$statusId", file);

      final statusModel = Status(
        statusId: statusId,
        statusType: statusType,
        statusContent: fileUrl,
        caption: caption,
        seenBy: [],
        createdAt: DateTime.now(),
      );

      await fireStore.collection("statusContacts").doc(uid).set(
          {
            "uid": uid,
            "userName": userModel.name,
            "profilePic": userModel.profilePic,
            "lastStatusTime": statusModel.createdAt,
            "completedBy": [auth.currentUser!.uid]
          }
      );
      await fireStore
          .collection("statusContacts")
          .doc(uid)
          .collection("statuses")
          .doc(statusId)
          .set(statusModel.toJson());


      //await userRef.collection("status").doc(statusId).set(statusModel.toJson());
    }
    catch(e){
      printError(info: e.toString());
    }
  }

  Future<List<String>> getContactsNumbers() async {
    List<Contact> contacts = [];
    List<String> numbers = [];

    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.add(Contact(phones: [
        Phone(
          auth.currentUser!.phoneNumber!,
          normalizedNumber: auth.currentUser!.phoneNumber!,
        )
      ]));
      for (final contact in contacts) {
        final phoneNumber = contact.phones[0].normalizedNumber;
        numbers.add(phoneNumber);
      }
    }
    return numbers;
  }

  /*
  Future<List<StatusContact>> getStatus() async {
    List<StatusContact> statusContacts = [];

    // GETTING THE CURRENT USER CONTACTS WITH PHONE NUMBERS
    final numbers = await getContactsNumbers();

    // GET FIREBASE USERS THAT HAS ANY OF THE PHONE NUMBERS
    final userSnapshot = await fireStore
        .collection("users")
        .where("phoneNumber", whereIn: numbers)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      for (final userDoc in userSnapshot.docs) {
        final statusSnapshot = await fireStore
            .collection("statusContacts")
            .doc(userDoc.id)
            .collection("statuses")
            .where("createdAt",
                isGreaterThan: DateTime.now().subtract(24.hours))
            .get();

        if (statusSnapshot.docs.isNotEmpty) {
          List<Status> statuses = [];
          for (final doc in statusSnapshot.docs) {
            Status status = Status.fromJson(doc.data());
            statuses.add(status);
          }
          statusContacts.add(StatusContact(
              statuses: statuses,
              lastStatusTime: statuses.last.createdAt,
              uid: userDoc.id,
              userName: userModel.n,
              profilePic: userModel.profilePic,
          ));
        }

        statusContacts
            .sort((a, b) => b.lastStatusTime.compareTo(a.lastStatusTime));
      }
    }
    return statusContacts;
  }

   */

  Stream<QuerySnapshot> getStatus2(){
    //Stream<List<String>> numbers = Stream.fromFuture(getContactsNumbers());
    return fireStore
        .collection("statusContacts")
        .where("lastStatusTime", isGreaterThanOrEqualTo: DateTime.now().subtract(24.hours))
        .orderBy("lastStatusTime", descending: true)
        .snapshots();
  }

  void completeStatus(String uid) async {
    try {
      await fireStore
          .collection("statusContacts")
          .doc(uid)
          .update({
        "completedBy": FieldValue.arrayUnion([auth.currentUser!.uid])
      });
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void updateStatusSeenBy(String uid, String statusId)async{
    if(uid != auth.currentUser!.uid){
      try {
        await fireStore
            .collection("statusContacts")
            .doc(uid)
            .collection("statuses")
            .doc(statusId)
            .update({
          "seenBy": FieldValue.arrayUnion([auth.currentUser!.uid])
        });
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }
}
