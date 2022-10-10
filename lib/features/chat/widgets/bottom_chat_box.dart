import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_reply_preview.dart';
import 'package:whatsapp_clone/features/group/controller/group_controller.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:get/get.dart';

class BottomChatBox extends ConsumerStatefulWidget {
  const BottomChatBox({
    Key? key,
    required this.chatModel,
    required this.scrollController,
  }) : super(key: key);

  final ChatModel chatModel;
  final ScrollController scrollController;

  @override
  ConsumerState<BottomChatBox> createState() => _BottomChatBoxState();
}

class _BottomChatBoxState extends ConsumerState<BottomChatBox> {
  bool showSendButton = false;
  bool showCamera = true;
  bool showEmojisKeyboard = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? soundRecorder;
  final _messageController = TextEditingController();
  bool isRecording = false;
  final groupController = Get.put(GroupController());

  @override
  void initState() {
    soundRecorder = FlutterSoundRecorder();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    soundRecorder?.closeRecorder();
    super.dispose();
  }

  void startRecording() async {
    if (await Permission.microphone.status != PermissionStatus.granted) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text(
                    "WhatsApp clone needs recording permission in order to achieve these operation"),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Not now",
                      style: TextStyle(color: tabColor),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: const Text("Continue",
                        style: TextStyle(color: tabColor)),
                  ),
                ],
              ));
    } else {
      final temp = await getTemporaryDirectory();
      final path = "${temp.path}/flutter_sound.aac";
      await soundRecorder?.openRecorder();

      if (!isRecording) {
        await soundRecorder?.startRecorder(toFile: path);
      }
      else{
        await soundRecorder?.stopRecorder();
        sendFileMessage(File(path), widget.chatModel.contactId, MessageEnum.audio);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUid,
  ) async {
    ref
        .read(chatControllerProvider)
        .sendTextMessage(context, text, receiverUid);
    _messageController.text = "";
    showSendButton = false;
    showCamera = true;
    setState(() {});
    widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
  }

  void sendGroupTextMessage(String message, String groupId){
    groupController.sendTextMessage(message, groupId);
    _messageController.text = "";
    showSendButton = false;
    showCamera = true;
    setState(() {});
    widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
  }

  void sendFileMessage(
      File file, String receiverUid, MessageEnum messageType) async {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, receiverUid, messageType);
  }

  void sendGIFMessage(BuildContext context, String gifURL, String receiverUid) {
    ref
        .read(chatControllerProvider)
        .sendGIFMessage(context, gifURL, receiverUid);
  }

  void selectImage() async {
    File? pickedImage = await pickImage(context);
    if (pickedImage != null) {
      sendFileMessage(pickedImage, widget.chatModel.contactId, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? pickedVideo = await pickVideo(context);
    if (pickedVideo != null) {
      sendFileMessage(pickedVideo, widget.chatModel.contactId, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(gif.title),
          content: GiphyImageView(
            gif: gif,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: tabColor),
                )),
            TextButton(
                onPressed: () {
                  sendGIFMessage(context, gif.url, widget.chatModel.contactId);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Send",
                  style: TextStyle(color: tabColor),
                ))
          ],
        ),
      );
    }
  }

  void onChanged(value) {
    if (value.trim().isNotEmpty) {
      if (!showSendButton) {
        setState(() {
          showCamera = false;
          showSendButton = true;
        });
      }
    } else {
      if (showSendButton) {
        setState(() {
          showCamera = true;
          showSendButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          isShowMessageReply ? const MessageReplyPreview() : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    if (showEmojisKeyboard) {
                      setState(() {
                        showEmojisKeyboard = false;
                      });
                    }
                  },
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (value) => onChanged(value),
                  maxLines: null,
                  cursorColor: tabColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    fillColor: mobileChatBoxColor,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: mobileChatBoxColor,
                            style: BorderStyle.none)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: dividerColor, style: BorderStyle.none)),
                    hintText: "Message",
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (showEmojisKeyboard) {
                              focusNode.requestFocus();
                            } else {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                            await Future.delayed(
                                const Duration(milliseconds: 50));
                            setState(() {
                              showEmojisKeyboard = !showEmojisKeyboard;
                            });
                          },
                          icon: Icon(
                            showEmojisKeyboard
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectGIF();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              "GIF",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            selectVideo();
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: showCamera,
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (showSendButton) {
                    if(widget.chatModel.type == "contact"){
                      sendTextMessage(context, _messageController.text.trim(),
                          widget.chatModel.contactId);
                      messageReply?.cancelReply(ref);
                    }
                    else{
                      sendGroupTextMessage(_messageController.text, widget.chatModel.contactId);
                    }
                  } else {
                    startRecording();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: tabColor, shape: BoxShape.circle),
                  child: Icon(showSendButton == true
                      ? Icons.send
                      : isRecording
                          ? Icons.close
                          : Icons.keyboard_voice),
                ),
              ),
            ],
          ),
          showEmojisKeyboard
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: EmojiPicker(
                    onEmojiSelected: ((category, emoji) {
                      _messageController.text += emoji.emoji;
                      if (!showSendButton) {
                        setState(() {
                          showSendButton = true;
                        });
                      }
                    }),
                    config: const Config(
                      bgColor: backgroundColor,
                      indicatorColor: tabColor,
                      iconColorSelected: Colors.white,
                      iconColor: Colors.grey,
                      progressIndicatorColor: tabColor,
                    ),
                  ))
              : Container()
        ],
      ),
    );
  }
}
