import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:intl/intl.dart';

  class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact?>>(
        stream: ref.watch(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final chatContact = snapshot.data![index];
                final int diffInDays = DateTime.now().difference(chatContact!.timeSent).inDays;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: (){
                      ref.read(chatControllerProvider).navigateToChatScreen(context, chatContact);
                    },
                    title: Text(
                      chatContact.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        chatContact.lastMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CachedNetworkImage(
                      imageUrl: chatContact.profilePic,
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
                        ? DateFormat("dd/MM/yyyy").format(chatContact.timeSent)
                        : diffInDays == 1
                      ? "Yesterday"
                      : DateFormat.Hm().format(chatContact.timeSent),style: const TextStyle(
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
