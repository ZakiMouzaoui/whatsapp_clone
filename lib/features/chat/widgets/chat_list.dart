import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/widgets/my_message_card.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList(
      {Key? key, required this.scrollController, required this.receiverId, required this.receiverName, })
      : super(key: key);

  final ScrollController scrollController;

  final String receiverId;
  final String receiverName;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();

}
class _ChatListState extends ConsumerState<ChatList>{
  final timeDiffs = [];

  void onMessageSwipe(String message, bool isMe, MessageEnum messageType, String repliedUserName){
    ref.read(messageReplyProvider.state).update((state) => MessageReply(
        message: message,
        isMe: isMe,
        messageType: messageType,
        repliedUserName: repliedUserName
    ));
  }

  @override
  Widget build(BuildContext context) {
    // scrollController.addListener(() {
    //   if(scrollController.offset > MediaQuery.of(context).size.height*0.2){
    //     _scrollController.toggleBtn(true);
    //   }
    //   else{
    //     _scrollController.toggleBtn(false);
    //   }
    // });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder<List<Message>>(
          stream: ref.read(chatControllerProvider).getChatMessages(widget.receiverId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final messages = snapshot.data!;
              return ListView.custom(
                  shrinkWrap: true,
                  reverse: true,
                  controller: widget.scrollController,
                  childrenDelegate: SliverChildBuilderDelegate(
                    childCount: messages.length,
                findChildIndexCallback: (key){
                      final valueKey = key as ValueKey<String>;
                      return messages.length - 1 - messages.indexWhere((element) => element.messageId == valueKey.value);
                },
                (context, index){
                  index = messages.length-1-index;
                  final message = messages[index];
                  if(message.senderId != widget.receiverId){
                    return MyMessageCard(
                      message: message,
                      key: ValueKey(message.messageId),
                      hasNip: index == 0 || messages[index-1].senderId == widget.receiverId,
                      userName: message.repliedTo,
                      repliedText: message.repliedMessage,
                      repliedMessageType: message.repliedMessageType,
                      onSwipeLeft: ()=>onMessageSwipe(message.text, true, message.messageType, "You"),
                    );
                  }
                  else{
                    return SenderMessageCard(
                      message: message,
                      key: ValueKey(message.messageId),
                      hasNip: index == 0 || messages[index-1].receiverId == widget.receiverId,
                      userName: message.repliedTo,
                      repliedText: message.repliedMessage,
                      repliedMessageType: message.repliedMessageType,
                      onSwipeRight: ()=>onMessageSwipe(message.text, false, message.messageType, widget.receiverName),
                    );
                  }
                },
              ),
              );
            }
            return const Loader();
          }
        ),
    );
  }
}
