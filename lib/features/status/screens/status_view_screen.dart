import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StatusViewScreen extends StatefulWidget {
  const StatusViewScreen({Key? key, required this.storyItems}) : super(key: key);

  final List<StoryItem> storyItems;

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final StoryController storyController = StoryController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        onVerticalSwipeComplete: (direction){
        },
          onComplete: (){
          print("stories completed");
          },
          storyItems: widget.storyItems,
          controller: storyController
      ),
    );
  }
}
