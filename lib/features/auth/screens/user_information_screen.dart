import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();

}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final _nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void storeUserData(){
    String name = _nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: image == null
              ? const NetworkImage(photoUrl)
                    : FileImage(image!) as ImageProvider,
                    radius: 65,
                  ),
                  Positioned(
                    bottom: 0,
                      left: 80,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: tabColor,
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: IconButton(onPressed: ()async{
                            final _image = await pickImage(context);
                            if(_image != null){
                              setState(() {
                                image = _image;
                              });
                            }
                          }, icon: const Icon(Icons.add_a_photo,)),
                        ),
                      )
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width*0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _nameController,
                      cursorColor: tabColor,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: tabColor
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: tabColor
                            )
                        )
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    storeUserData();
                  }, icon: const Icon(Icons.done))
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
