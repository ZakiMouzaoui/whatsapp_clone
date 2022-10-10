import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/group/controller/group_controller.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

  class ContactsList extends ConsumerWidget {
  ContactsList({Key? key}) : super(key: key);

  final groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatModel?>>(
        stream: ref.read(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final chatModel = snapshot.data![index];
                final int diffInDays = DateTime.now().difference(chatModel!.timeSent).inDays;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: (){
                      if(chatModel.type == "contact"){
                        ref.read(chatControllerProvider).navigateToChatScreen(context, chatModel);
                      }
                      else{
                        groupController.navigateToChatScreen(context, chatModel);
                      }
                    },
                    title: Text(
                      chatModel.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        chatModel.lastMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CachedNetworkImage(
                      imageUrl: chatModel.profilePic,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: tabColor,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    trailing: Text(
                      diffInDays >= 2
                        ? DateFormat("dd/MM/yyyy").format(chatModel.timeSent)
                        : diffInDays == 1
                      ? "Yesterday"
                      : DateFormat.Hm().format(chatModel.timeSent),style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey
                    ),),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                );
              },);
          }
          return const Loader();
        }
      ),
    );
  }
}
