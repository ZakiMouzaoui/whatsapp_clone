import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Stack(
      children: [
        Container(
        width: MediaQuery.of(context).size.width*0.79,
        decoration: BoxDecoration(
          color: chatBarMessage,
          borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messageReply!.repliedUserName, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: messageReply.isMe ? tabColor : Colors.purpleAccent
                    ),),
                    // GestureDetector(
                    //   onTap: (){
                    //     messageReply.cancelReply(ref);
                    //   },
                    //   child: const Icon(Icons.close, size: 16,),
                    // )

                const SizedBox(height: 8,),
                Text(
                    messageReply.messageType.type == "text"
                        ? messageReply.message
                        : messageReply.messageType.type == "image"
                        ? "Photo"
                        : messageReply.messageType.type == "video"
                        ? "Video"
                        : messageReply.messageType.type == "audio"
                        ? "Audio"
                        : messageReply.messageType.type == "gif"
                        ? "Gif" : ""
                )
              ],
            ),
          ],
        )
      ),
        Positioned(
          right: 0,
          child: Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
              image: messageReply.messageType.type == "image" ? DecorationImage(image: CachedNetworkImageProvider(
                messageReply.message
              ),fit: BoxFit.cover) : null,
            ),
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(3),
            child: GestureDetector(
                onTap: (){
                  messageReply.cancelReply(ref);
                },
                child: const Icon(Icons.close,size: 15,)),

          ),
        )
  ]
    );
  }
}
