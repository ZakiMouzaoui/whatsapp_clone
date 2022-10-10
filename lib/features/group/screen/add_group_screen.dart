import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/group/controller/group_controller.dart';

class AddGroupScreen extends  ConsumerWidget {
  AddGroupScreen({Key? key, required this.contacts}) : super(key: key);

  final List<Contact> contacts;
  final groupController = Get.put(GroupController());
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("New group"),
            Text(
              "add subject",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // GROUP DETAILS
          Stack(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: chatBarMessage),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<GroupController>(
                      builder: (context) {
                        return CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 25,
                          backgroundImage: groupController.imagePath != ""
                          ? FileImage(File(groupController.imagePath)) : null,
                          child: groupController.imagePath == ""
                          ? const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ) : null,
                        );
                      }
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return "PLease enter the group's name";
                                }
                                return null;
                              },
                              controller: nameController,
                              maxLength: 25,
                              cursorColor: tabColor,
                              decoration: const InputDecoration(
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.only(bottom: 5),
                                  hintText: "Type group subject here...",
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: tabColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: tabColor))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.emoji_emotions_rounded,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 35,
                  child: GestureDetector(
                    onTap: () async {
                      final pickedImage = await pickImage(context);
                      if (pickedImage != null) {
                        groupController.changePic(pickedImage.path);
                      }
                    },
                    child: const CircleAvatar(
                        backgroundColor: tabColor,
                        radius: 12,
                        child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                    )
                  )
              )
            ],
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 10),
                    child: Text(
                      "Participants: ${contacts.length}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GridView.builder(
                          itemCount: contacts.length,
                          padding: const EdgeInsets.all(0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 15,
                          ),
                          itemBuilder: (_, index) {
                            final contact = contacts[index];
                            return SizedBox(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: tabColor,
                                    radius: 28,
                                    backgroundImage: contact.photo != null
                                        ? MemoryImage(contact.photo!)
                                            as ImageProvider
                                        : const CachedNetworkImageProvider(
                                            "https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png"),
                                  ),
                                  Text(
                                    contact.displayName,
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          if(_formKey.currentState!.validate()){
            showLoadingDialog(context);
            await groupController.addGroup(nameController.text, File(groupController.imagePath), contacts).then((value){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
        },
        backgroundColor: tabColor,
        child: const Icon(Icons.done_rounded, color: Colors.white,),
      ),
    );
  }
}
