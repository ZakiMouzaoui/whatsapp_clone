import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/message_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_box.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ChatScreen extends ConsumerWidget{
  ChatScreen({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  final ScrollController scrollController = ScrollController();
  final messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: ()async{
        scrollController.dispose();
        return true;
      },
      child: GetBuilder<MessageController>(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: messageController.selectedCount > 0
                  ? Text(messageController.selectedCount.toString()) : StreamBuilder<UserModel>(
                    stream: ref
                        .watch(authControllerProvider)
                        .userDataById(chatModel.contactId),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.profilePic,
                                  ),
                                  radius: 15,
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 20,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: snapshot.data!.isOnline
                                              ? tabColor
                                              : Colors.grey[400]),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.name),
                                snapshot.data!.isOnline ? const Text("online", style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal
                                ),) : Container()
                              ],
                            )
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                    }),
                actions: [
                  messageController.selectedCount > 0 ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: (){
                      ref.read(chatRepositoryProvider).deleteChatMessages(messageController.selectedMessages, chatModel.contactId);
                      messageController.reset();
                      
                    }, child: const Icon(Icons.delete_rounded)),
                  ) : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: () {}, child: const Icon(Icons.video_call)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: () {}, child: const Icon(Icons.call)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: () {}, child: const Icon(Icons.more_vert)),
                  )
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
                    BottomChatBox(chatModel: chatModel, scrollController: scrollController,),
                    // TextFormField(
                    // )
                    // TEXT INPUT
                  ],
                ),
              ),
            );
        }
      ),
    );
  }
}
