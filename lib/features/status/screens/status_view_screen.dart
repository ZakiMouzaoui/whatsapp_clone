import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';

class StatusViewScreen extends ConsumerStatefulWidget {
  const StatusViewScreen({
    Key? key,
    required this.storyItems,
    required this.uid,
    required this.statusDocs,
  }) : super(key: key);

  final List<StoryItem> storyItems;
  final String uid;
  final List<QueryDocumentSnapshot> statusDocs;

  @override
  ConsumerState<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends ConsumerState<StatusViewScreen> {
  final StoryController storyController = StoryController();
  int currentIndex = 1;
  bool seeCounter = true;
  int viewsCount = 0;

  @override
  void initState() {
    storyController.playbackNotifier.listen((value) {
      if(value == PlaybackState.next){
        currentIndex += 1;
        if(currentIndex == widget.storyItems.length){
          ref.read(statusRepositoryProvider).completeStatus(
            widget.uid,
          );
        }
      }
      else if(value == PlaybackState.previous){
        currentIndex -= 1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onSecondaryLongPress: (){
              setState(() {
                seeCounter = false;
              });
              storyController.pause();
            },
            onSecondaryLongPressCancel: (){
              setState(() {
                seeCounter = true;
              });
            },
            child: StoryView(
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
              onComplete: () {
                Navigator.pop(context);
              },
              onStoryShow: (storyItem) async{
                ref.read(statusRepositoryProvider).updateStatusSeenBy(
                    widget.uid, widget.statusDocs[currentIndex-1].id
                );
                await Future.delayed(Duration.zero);
                setState(() {
                  viewsCount = widget.statusDocs[currentIndex-1].get("seenBy").length;
                });
              },
              storyItems: widget.storyItems,
              controller: storyController,
            ),
          ),
          seeCounter
              ?Align(alignment: Alignment.bottomCenter, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.remove_red_eye_outlined),
                  const SizedBox(width: 5,),
                  Text(viewsCount.toString())
                ],
              ))
              : Container()
        ]
      ),
    ));
  }
}
