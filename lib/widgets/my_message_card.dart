import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/features/chat/controller/message_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/audio_player_item.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:get/get.dart';

class MyMessageCard extends StatefulWidget {
  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.hasNip,
      this.gif,
      required this.onSwipeLeft,
      required this.repliedText,
      required this.userName,
      required this.repliedMessageType})
      : super(key: key);

  final Message message;
  final bool hasNip;
  final GiphyGif? gif;
  final VoidCallback onSwipeLeft;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  @override
  State<MyMessageCard> createState() => _MyMessageCardState();
}

class _MyMessageCardState extends State<MyMessageCard>
    with SingleTickerProviderStateMixin {
  late GifController _controller;
  double? bubbleWidth;
  double? messageWidth;
  double? bubbleHeight;
  bool selected = false;

  final messageController = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderObject? renderObject =
          _globalKey.currentContext?.findRenderObject();
      RenderObject? renderObject1 =
          _messageKey.currentContext?.findRenderObject();

      setState(() {
        if (renderObject != null) {
          RenderBox renderBox = renderObject as RenderBox;
          bubbleWidth = renderBox.size.width;
          bubbleHeight = renderBox.size.height;
        }
        if (renderObject1 != null) {
          RenderBox renderBox1 = renderObject as RenderBox;
          messageWidth = renderBox1.size.width;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _messageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.message.diff != null
            ? Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: Bubble(
                    margin: const BubbleEdges.only(top: 10, bottom: 10),
                    color: senderMessageColor,
                    child: Center(
                      child: Text(widget.message.diff! < 1
                          ? "Today"
                          : widget.message.diff == 1
                              ? "Yesterday"
                              : DateFormat("dd MMMM yyyy")
                                  .format(widget.message.timeSent)),
                    ),
                  ),
                ),
              )
            : Container(),
        SwipeTo(
          onLeftSwipe: widget.onSwipeLeft,
          child: GestureDetector(
            onLongPress: () {
              messageController.selectMessage(widget.message.messageId);
            },
            onTap: () {
              messageController.selectedCount > 0
                  ? messageController.selectMessage(widget.message.messageId)
                  : null;
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    key: _globalKey,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 45,
                    ),
                    child: Bubble(
                        margin: BubbleEdges.only(
                            top: 5, right: widget.hasNip ? 0 : 8),
                        padding: const BubbleEdges.all(0),
                        stick: false,
                        nip: widget.hasNip ? BubbleNip.rightTop : null,
                        color: messageColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.repliedText.isNotEmpty
                                ? ConstrainedBox(
                                    constraints: bubbleWidth != null
                                        ? BoxConstraints(minWidth: bubbleWidth!)
                                        : const BoxConstraints(),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: messageReplyColor,
                                      ),
                                      margin: const EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          top: 5,
                                          bottom: 5,
                                          right: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.userName,
                                            style: TextStyle(
                                                color: widget.userName == "You"
                                                    ? tabColor
                                                    : Colors.deepPurple[200],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            widget.repliedMessageType.type ==
                                                    "text"
                                                ? widget.repliedText
                                                : widget.repliedMessageType
                                                            .type ==
                                                        "image"
                                                    ? "Photo"
                                                    : widget.repliedMessageType
                                                                .type ==
                                                            "video"
                                                        ? "Video"
                                                        : widget.repliedMessageType
                                                                    .type ==
                                                                "audio"
                                                            ? "Audio"
                                                            : widget.repliedMessageType
                                                                        .type ==
                                                                    "gif"
                                                                ? "Gif"
                                                                : "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[300],
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                  ),

                            // SECOND COLUMN
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // MESSAGE
                                widget.message.messageType.type == "text"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 5),
                                        key: _messageKey,
                                        child: Text(widget.message.text,
                                            textAlign: TextAlign.right),
                                      )
                                    : widget.message.messageType.type == "image"
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: OptimizedCacheImage(
                                                imageUrl: widget.message.text,
                                                imageBuilder: (_, provider) {
                                                  //double width = MediaQuery.of(context).size.width*0.75;
                                                  return Container(
                                                    //width: width,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: provider,
                                                            fit: BoxFit.cover)),
                                                  );
                                                },
                                                progressIndicatorBuilder:
                                                    (_, __, download) => Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: download.progress,
                                                    color: tabColor,
                                                  ),
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : widget.message.messageType.type ==
                                                "video"
                                            ? VideoPlayerItem(
                                                videoUrl: widget.message.text)
                                            : widget.message.messageType.type ==
                                                    "gif"
                                                ? SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://i.giphy.com/media/${widget.message.text.split("-").last}/200.gif",
                                                        imageBuilder:
                                                            (_, provider) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              _controller
                                                                  .reset();
                                                              _controller
                                                                  .forward();
                                                            },
                                                            child: Gif(
                                                              controller:
                                                                  _controller,
                                                              image: NetworkImage(
                                                                  "https://i.giphy.com/media/${widget.message.text.split("-").last}/200.gif"),
                                                              onFetchCompleted:
                                                                  () {
                                                                _controller
                                                                    .reset();
                                                                _controller
                                                                    .forward();
                                                              },
                                                              fit: BoxFit.fill,
                                                            ),
                                                          );
                                                        },
                                                        progressIndicatorBuilder:
                                                            (_, __, download) =>
                                                                Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: download
                                                                .progress,
                                                            color: tabColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                : AudioPlayerItem(
                                                    url: widget.message.text,
                                                  ),

                                // TIME AND MESSAGE STATUS
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 3, left: 10, right: 10),
                                  child: SizedBox(
                                    width: bubbleWidth != null
                                        ? bubbleWidth! - 15
                                        : 0,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          //SizedBox(width: messageWidth != null ? messageWidth! -10 : 0,),
                                          //const Expanded(child: SizedBox()),
                                          Text(
                                            DateFormat.Hm().format(
                                                widget.message.timeSent),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white60),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.done_all,
                                            size: 20,
                                            color: widget.message.isSeen
                                                ? Colors.blue
                                                : Colors.white60,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                messageController.selectedMessages
                        .contains(widget.message.messageId)
                    ? Positioned(
                        child: Container(
                          width: double.infinity,
                          height: bubbleHeight != null ? bubbleHeight! + 5 : 40,
                          decoration: BoxDecoration(
                              color: tabColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
