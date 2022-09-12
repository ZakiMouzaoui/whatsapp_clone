import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';
import 'package:whatsapp_clone/models/message.dart';

class SenderMessageCard extends StatefulWidget {
  const SenderMessageCard({Key? key, required this.message, required this.hasNip, this.gif, required this.onSwipeRight, required this.repliedText, required this.userName, required this.repliedMessageType}) : super(key: key);

  final Message message;
  final bool hasNip;
  final GiphyGif? gif;
  final VoidCallback onSwipeRight;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> with SingleTickerProviderStateMixin{
  late GifController _controller;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: widget.onSwipeRight,
      child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.message.diff != null ? Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width*0.4
                    ),
                    child: Bubble(
                      margin: const BubbleEdges.only(top: 10, bottom: 10),
                      color: senderMessageColor,
                      child: Center(
                        child: Text(widget.message.diff! < 1 ? "Today" : widget.message.diff == 1 ? "Yesterday" : DateFormat("dd MMMM yyyy").format(widget.message.timeSent)),
                      ),
                    ),
                  ),
                ):Container(),
                Bubble(
                    margin: BubbleEdges.only(top: 5, left: widget.hasNip ? 0 : 8),
                    padding: const BubbleEdges.all(0),
                    stick: false,
                    nip: widget.hasNip ? BubbleNip.leftTop : null,
                    color: senderMessageColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.message.messageType.type == "text"
                            ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 5),
                            child: Text(widget.message.text, textAlign: TextAlign.right))
                            : widget.message.messageType.type == "image"
                        ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ) : widget.message.messageType.type == "video"
                        ? VideoPlayerItem(videoUrl: widget.message.text) : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CachedNetworkImage(
                                imageUrl: "https://i.giphy.com/media/${widget.message.text.split("-").last}/200.gif",
                                imageBuilder: (_,provider){
                                  return GestureDetector(
                                    onTap: (){
                                      _controller.reset();
                                      _controller.forward();
                                    },
                                    child: SizedBox(
                                      child: Gif(
                                        controller: _controller,
                                        image: NetworkImage("https://i.giphy.com/media/${widget.message.text.split("-").last}/200.gif"),
                                        onFetchCompleted: () {
                                          _controller.reset();
                                          _controller.forward();
                                        },
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },

                                progressIndicatorBuilder: (_,__, download)=>Center(
                                  child: CircularProgressIndicator(
                                    value: download.progress,
                                    color: tabColor,
                                  ),
                                ),
                              ),

                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, bottom: 3, left: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat.Hm().format(widget.message.timeSent),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white60),
                              ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // Icon(
                              //   Icons.done_all,
                              //   size: 20,
                              //   color: message.isSeen ? Colors.blue : Colors.white60,
                              // )
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}
