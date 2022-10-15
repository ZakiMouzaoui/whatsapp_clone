import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';

class ImagePreviewScreen extends ConsumerStatefulWidget {
  const ImagePreviewScreen({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  ConsumerState<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends ConsumerState<ImagePreviewScreen> {
  TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.file(File(widget.path), fit: BoxFit.cover),
            ),
          ),
          Positioned(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Add a caption ...",
                          filled: true,
                          fillColor: chatBarMessage,
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(style: BorderStyle.none)),
                          focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(style: BorderStyle.none)),
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
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_)=>AlertDialog(
                              backgroundColor: searchBarColor,
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: const [
                                        Loader(),
                                        SizedBox(width: 10,),
                                        Text(
                                          "Please wait ...",
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );

                        await ref.read(statusControllerProvider).addFileStatus(
                            File(widget.path), captionController.text.trim(), null, StatusEnum.video
                        ).then((_){
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showSnackBar(context: context, content: "Status added");
                        });
                      },
                      child: const CircleAvatar(
                        backgroundColor: tabColor,
                        radius: 25,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
