import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_box.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/scroll_controller.dart';

class ChatScreen extends ConsumerWidget{
  ChatScreen({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: ()async{
        scrollController.dispose();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: StreamBuilder<UserModel>(
                stream: ref
                    .watch(authControllerProvider)
                    .userDataById(userModel.uid),
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
                    receiverId: userModel.uid,
                    receiverName: userModel.name,
                  ),
                ),
                
                //BOTTOM INPUT FIELD
                BottomChatBox(userModel: userModel, scrollController: scrollController,),
                // TextFormField(
                // )
                // TEXT INPUT
              ],
            ),
          ),
          // floatingActionButton: Stack(children: [
          //   Positioned(
          //     bottom: MediaQuery.of(context).size.height * 0.1,
          //     left: MediaQuery.of(context).size.width * 0.9,
          //     child: SizedBox(
          //       width: 35,
          //       child: FloatingActionButton(
          //           backgroundColor: senderMessageColor,
          //           onPressed: () {
          //             scrollController.jumpTo(
          //               scrollController.position.minScrollExtent,
          //             );
          //           },
          //           child: const Icon(
          //             Icons.keyboard_double_arrow_down,
          //             color: Colors.white60,
          //             size: 18,
          //           )),
          //     ),
          //   ),
          // ])

        ),
    );
  }
}
