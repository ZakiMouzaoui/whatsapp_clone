import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_box.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/models/chat_model.dart';

class GroupChatScreen extends ConsumerWidget{
  GroupChatScreen({Key? key, required this.chatModel}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: ()async{
        scrollController.dispose();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(chatModel.name),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/chat-bg.png"), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CHAT LIST
              Expanded(
                child: ChatList(
                  scrollController: scrollController,
                  receiverId: chatModel.contactId,
                  receiverName: chatModel.name,
                ),
              ),

              //BOTTOM INPUT FIELD
              BottomChatBox(chatModel: chatModel, scrollController: scrollController),
              // TextFormField(
              // )
              // TEXT INPUT
            ],
          ),
        ),
      ),
    );
  }
}
