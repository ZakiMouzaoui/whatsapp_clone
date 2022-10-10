import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/select_contacts/repository/select_contact_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final getContactsProvider = FutureProvider<List<dynamic>>((ref){
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getWhatsappContacts();
});

final selectContactController = Provider((ref){
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(ref: ref, selectContactRepository: selectContactRepository);
});

class SelectContactController{
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({required this.ref, required this.selectContactRepository});

  void selectContact(UserModel selectedContact, BuildContext context){
    selectContactRepository.selectContact(selectedContact, context);
  }

  Stream<List<dynamic>> getWhatsappContacts(){
    return Stream.fromFuture(selectContactRepository.getWhatsappContacts());
  }
}
