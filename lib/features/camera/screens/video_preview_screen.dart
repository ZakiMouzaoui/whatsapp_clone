import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  ConsumerState<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}


class _VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late CachedVideoPlayerController videoPlayerController;
  bool _visible = false;
  TextEditingController captionController = TextEditingController();

  @override
  void initState(){
    initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  void initVideoPlayer()async{
    videoPlayerController = CachedVideoPlayerController
        .file(File(widget.path))..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onTap: ()async{
                  if(videoPlayerController.value.isPlaying) {
                    await videoPlayerController.pause();
                  }
                  else{
                    await videoPlayerController.play();
                  }
                  setState(() {
                    _visible = !_visible;
                  });
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height,
                  child: CachedVideoPlayer(videoPlayerController)
                ),
              ),
              AnimatedOpacity(
                opacity: _visible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Align(
                  alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 30, backgroundColor: Colors.black38,
                  child: !videoPlayerController.value.isPlaying
                      ?const Icon(
                     Icons.play_arrow,
                    size: 40,
                  ) : Container())
                ),
              ),
              Positioned(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Row(
                  children: [
                    InkWell(onTap: (){
                      Navigator.pop(context);
                    },child: const Icon(Icons.close)),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: const [
                        Icon(Icons.crop_rotate),
                        Icon(Icons.title),
                        Icon(Icons.emoji_emotions_outlined),
                      ],
                    )
                  ],
                ),
              )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child:  Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Add a caption ...",
                              filled: true,
                              fillColor: chatBarMessage,
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none
                                  )
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none
                                  )
                              ),
                              prefixIcon: const Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.grey,
                                ),
                              ),
                              //contentPadding: const EdgeInsets.all(10),
                            ),
                            controller: captionController,
                            cursorColor: tabColor,
                            maxLines: null,

                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: ()async{
                            showLoadingDialog(context);

                            await ref.read(statusControllerProvider).addFileStatus(
                                File(widget.path), captionController.text.trim(), videoPlayerController.value.duration.inMilliseconds, StatusEnum.video
                            ).then((_){
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showSnackBar(context: context, content: "Status added");
                            });

                          },
                          child: const CircleAvatar(
                            backgroundColor: tabColor,
                            radius: 25,
                            child: Icon(Icons.check, color: Colors.white,),
                          ),
                        )
                      ],
                    ),

                  ))
            ],
          )

      ),
    );
  }
}
