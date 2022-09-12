import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/status/screens/contact_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_view_screen.dart';
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
    tabController = TabController(length: 3, vsync: this, animationDuration: Duration.zero)..addListener(() {
      // setState(() {
      //
      // });
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
              controller: tabController, children: [
            const ContactsList(),
            ContactStatusScreen(profilePic: widget.profilePic, uid: widget.uid,),
            const Text("CALLS PAGES")
          ],),
          floatingActionButton: FloatingActionButton(
            onPressed: tabController.index == 0 ? (){
              Navigator.pushNamed(context, "/select-contact");
            } : (){

            },
            backgroundColor: tabColor,
            child: tabController.index == 0
                ? const Icon(Icons.comment_rounded, color: Colors.white,)
                : tabController.index == 1 ? const Icon(Icons.camera_alt, color: Colors.white,)
                : const Icon(Icons.dialer_sip, color: Colors.white,),
          ),
        )
    );
  }
}
