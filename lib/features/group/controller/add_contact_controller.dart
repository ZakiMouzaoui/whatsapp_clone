import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class AddContactController extends GetxController{
  List<Contact> contacts = [];
  List<Contact> found = [];
  List<Contact> selected = [];
  bool loading = false;
  int selectedCount= 0;
  bool searching = false;

  @override
  void onInit() {
    super.onInit();
    getContacts();
  }

  void getContacts()async{
    loading = true;
    update();
    if(await FlutterContacts.requestPermission()){
      final contactList = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      contacts.assignAll(contactList);
      found.assignAll(contacts);
      loading = false;
      update();
    }
  }

  void addContact(index){
    final contact = found[index];
    int contactIndex = selected.indexWhere((element) => element.phones == contact.phones);
    if(contactIndex != -1){
      selected.removeAt(contactIndex);
      selectedCount -= 1;
    }
    else{
      selected.add(contact);
      selectedCount += 1;
    }
    update();
  }

  void removeContact(index){
    selected.removeAt(index);
    selectedCount -= 1;
    update();
  }

  void changeSearchState(bool state){
    searching = state;
    update();
  }

  void filter(String key){
    if(key.isNotEmpty){
      found.assignAll(contacts.where((element) => element.displayName.toLowerCase().contains(key.toLowerCase())).toList());
    }
    else{
      found.assignAll(contacts);
    }
    update();
  }

  void resetSearch(){
    found.assignAll(contacts);
    update();
  }

 void clearSelected(){
    selected.clear();
    selectedCount = 0;
    found.assignAll(contacts);
 }
}

