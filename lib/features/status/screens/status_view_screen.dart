import 'package:advstory/advstory.dart';
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
  final AdvStoryController advStoryController = AdvStoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StoryView(
          onVerticalSwipeComplete: (direction){
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
            onComplete: (){
            Navigator.pop(context);
            },
            onStoryShow: (storyItem){
              print(storyItem);
            },

            storyItems: widget.storyItems,
            controller: storyController,

        ),
        // body: AdvStory(
        //   preloadContent: true,
        //   controller: advStoryController,
        //   storyCount: 1,
        //   storyBuilder: (index)=>Story(
        //       footer: Text("footer"),
        //       contentCount: 3,
        //       contentBuilder: (contentIndex)=>SimpleCustomContent(builder: (_) { return Center(
        //         child: Text("Hello"),
        //       ); },)
        //
        //   ), trayBuilder: (int storyIndex) {
        //     return AdvStoryTray(url: "",username: Text("zaki"),size: Size(50,50),);
        // },
        // ),
      )

    );
  }
}
