import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/camera/screens/camera_screen.dart';
import 'package:whatsapp_clone/features/status/screens/contact_status_screen.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';

class MobileScreenLayout extends ConsumerStatefulWidget{
  const MobileScreenLayout({Key? key, required this.profilePic, required this.uid, }) : super(key: key);
  final String profilePic;
  final String uid;

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  late TabController tabController;
  int index=1;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authRepositoryProvider).setUserStatus(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authRepositoryProvider).setUserStatus(false);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, animationDuration: Duration.zero, initialIndex: index)..addListener(() {
      setState(() {

      });
    });
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }

  void selectImage()async{
    File? image = await pickImage(context);
    if(image != null){
      navigateToImagePreviewScreen(image);
    }
  }

  void selectCamera()async{
    File? image = await openCamera(context);
    if(image != null){
      navigateToImagePreviewScreen(image);
    }
  }

  void navigateToImagePreviewScreen(File image){
    Navigator.pop(context);
    Navigator.pushNamed(context, "/image-preview", arguments: {
      "path": image.path
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Whatsapp",style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.grey,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.grey,))
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: tabColor,
              indicatorWeight: 4,
              labelColor: tabColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold
              ),
              tabs: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Icon(Icons.camera_alt)
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("CHATS"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("STATUS"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("CALLS"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              const CameraScreen(),
              const ContactsList(),
              ContactStatusScreen(profilePic: widget.profilePic, uid: widget.uid,),
              const Text("CALLS PAGES")
          ],),
          floatingActionButton: tabController.index != 0 ? FloatingActionButton(
            onPressed: tabController.index == 1 ? (){
              Navigator.pushNamed(context, "/select-contact");
            } : (){
              showDialog(
                  context: context,
                  builder: (context)=>SimpleDialog(
                    children: [
                      SimpleDialogOption(
                        onPressed: (){
                          selectImage();
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.photo),
                            SizedBox(width: 5,),
                            Text("Open Gallery"),
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/camera");
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt),
                            SizedBox(width: 5,),
                            Text("Open Camera"),
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.cancel),
                            SizedBox(width: 5,),
                            Text("Cancel"),
                          ],
                        ),
                      )
                    ],
                  )
              );
            },
            backgroundColor: tabColor,
            child: tabController.index != 0 ?
            tabController.index == 1
                ? const Icon(Icons.comment_rounded, color: Colors.white,)
                : tabController.index == 2 ? const Icon(Icons.camera_alt, color: Colors.white,)
                : const Icon(Icons.dialer_sip, color: Colors.white,) : Container(),
          ) : Container(),
        )
    );
  }
}
