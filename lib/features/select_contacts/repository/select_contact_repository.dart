import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final selectContactRepositoryProvider = Provider((ref)=>SelectContactRepository(fireStore: FirebaseFirestore.instance));
class SelectContactRepository{
  FirebaseFirestore fireStore;

  SelectContactRepository({required this.fireStore});

  Future<List<Contact>> getContacts()async{
    List<Contact> contacts = [];

    try{
      if(await FlutterContacts.requestPermission()){
        contacts  = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      }
    }
    catch(e){
      //TODO
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context)async{
    try{
      var userCollection = await fireStore.collection("users").get();
      bool isFound = false;

      for(var document in userCollection.docs){
        var userModel = UserModel.fromJson(document.data());
        String selectedPhoneNumber = selectedContact.phones[0].normalizedNumber.replaceAll(" ", "");
        if(selectedPhoneNumber == userModel.phoneNumber){
          isFound = true;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushNamed(context, "/chat", arguments: userModel);
        }
      }
      if(!isFound){
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showSnackBar(context: context, content: "These contact is not using whatsapp");
      }
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }
}
