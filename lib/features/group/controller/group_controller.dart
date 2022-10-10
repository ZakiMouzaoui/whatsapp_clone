import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/features/group/repository/group_repository.dart';
import 'package:whatsapp_clone/models/chat_model.dart';

class GroupController extends GetxController{
  String imagePath = "";
  final groupRepository = Get.put(GroupRepository());

  void changePic(String pickedImage){
    imagePath = pickedImage;
    update();
  }

  Future addGroup(String name, File groupPic, List<Contact> members)async{
    await groupRepository.addGroup(name, groupPic, members);
  }

  void sendTextMessage(String message, String groupId){
    groupRepository.sendTextMessage(message: message, groupId: groupId);
  }

  void navigateToChatScreen(BuildContext context, ChatModel chatModel){
    Navigator.pushNamed(context,  "/group-chat", arguments: {
      "chatModel": chatModel
    });
  }
}
