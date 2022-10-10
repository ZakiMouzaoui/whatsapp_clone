import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final selectContactRepositoryProvider = Provider((ref)=>SelectContactRepository(fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));
class SelectContactRepository{
  FirebaseFirestore fireStore;
  FirebaseAuth auth;

  SelectContactRepository({required this.fireStore, required this.auth});

  Future<List<dynamic>> getWhatsappContacts()async{
    List<Contact> contacts = [];
    List<String> numbers = [];
    List<Contact> nonWhatsapp = [];
    List<dynamic> result = [];

    try{
      if(await FlutterContacts.requestPermission()){
        contacts  = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
        nonWhatsapp = await getNonWhatsappContacts(contacts);
        for(final contact in contacts){
          numbers.add(contact.phones[0].normalizedNumber);
        }
      }
    }
    catch(e){
      //TODO
    }
    final userCollection = await fireStore.collection("users").where("phoneNumber", whereIn: numbers).get();
    result.add(userCollection.docs);
    result.add(nonWhatsapp);
    return result;
  }

  Future<List<Contact>> getNonWhatsappContacts(List<Contact> contacts)async{
    List<Contact> nonWhatsappContacts = [];

    try{
      for(final contact in contacts){
        if(contact.phones.isNotEmpty){
          final userDoc = await fireStore.collection("users").where("phoneNumber", isNotEqualTo: contact.phones[0].normalizedNumber).limit(1).get();
          if(userDoc.size != 0){
            nonWhatsappContacts.add(contact);
          }
        }
      }
    }
    catch(e){
      printError(info: e.toString());
    }
    return nonWhatsappContacts;
  }

  void selectContact(UserModel selectedContact, BuildContext context)async{
    try{
      await fireStore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .where("contactId", isEqualTo: selectedContact.uid)
          .limit(1)
          .get().then((value){
            ChatModel chatModel;
        if(value.docs.isNotEmpty){
          final chatDoc = value.docs[0];
          chatModel = ChatModel.fromJson(chatDoc.data());
        }
        else{
          chatModel = ChatModel(
              name: selectedContact.name,
              profilePic: selectedContact.profilePic,
              phoneNumber: selectedContact.phoneNumber,
              contactId: selectedContact.uid,
              lastMessage: "",
              timeSent: DateTime.now(),
              type: 'contact');
        }
        navigateToChatScreen(context, chatModel);
      });
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void navigateToChatScreen(BuildContext context, ChatModel chatModel){
    Navigator.pushNamed(context, "/chat", arguments: chatModel);
  }
}
