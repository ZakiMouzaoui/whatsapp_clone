import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/add_status_controller.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';

class ContactStatusScreen extends ConsumerStatefulWidget {
  const ContactStatusScreen({Key? key, required this.profilePic, required this.uid}) : super(key: key);
  final String profilePic;
  final String uid;

  @override
  ConsumerState<ContactStatusScreen> createState() => _ContactStatusScreenState();
}

class _ContactStatusScreenState extends ConsumerState<ContactStatusScreen> {
  final addStatusController = Get.put(AddStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, "/camera");
              },
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      widget.profilePic,
                    ),
                    radius: 25,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: tabColor
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              title:  const Text("My status", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: const Text("Tap to add a status", style: TextStyle(color: Colors.grey),),
            ),
            const SizedBox(height: 5,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Text("Updated views", style: TextStyle(
                color: Colors.grey
              ),),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: ref.read(statusRepositoryProvider).getStatus2(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (_,index){
                        final statusContact = snapshot.data!.docs[index];
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("statusContacts")
                              .doc(statusContact.id)
                              .collection("statuses")
                              .where("createdAt",
                              isGreaterThanOrEqualTo: DateTime.now().subtract(24.hours))
                              .snapshots(),

                          builder: (context, snapshot2) {
                            if(snapshot2.hasData){
                              final statuses = snapshot2.data!;
                              final lastStatusTime = statusContact.get("lastStatusTime").toDate();

                              return GetBuilder<AddStatusController>(
                                builder: (_) => ListTile(
                                  onTap: (){
                                    List<StoryItem> storyItems = [];
                                    for(final statusDoc in statuses.docs){
                                      if(statusDoc.get("statusType") == "text"){
                                        storyItems.add(
                                            StoryItem.text(
                                                title: statusDoc.get("statusContent"),
                                                backgroundColor: addStatusController.colors[statusDoc.get("backgroundColor")]!,
                                                textStyle: const TextStyle(
                                                    fontSize: 25
                                                )
                                            )
                                        );
                                      }
                                      else if(statusDoc.get("statusType") == "image"){
                                        storyItems.add(
                                          StoryItem.pageImage(
                                              url: statusDoc.get("statusContent"), controller: StoryController(),
                                              caption: statusDoc.get("caption")
                                          )
                                        );
                                      }
                                    }
                                    Navigator.pushNamed(context, "/view-status", arguments: {
                                      "storyItems": storyItems,
                                      "uid": statusContact.id,
                                      "statusDocs": statuses.docs
                                    });
                                  },
                                  leading: DashedCircle(
                                    dashes: statuses.docs.length,
                                    gapSize: statuses.docs.length > 1 ? 3 : 0,
                                    color: statusContact.get("completedBy").contains(widget.uid)
                                      ? Colors.grey : tabColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        backgroundImage: CachedNetworkImageProvider(
                                            statusContact.get("profilePic")
                                        ),
                                        radius: 25,
                                      ),
                                    ),
                                  ),
                                  title: Text(statusContact.id == widget.uid ? "My status" : statusContact.get("userName"), style: const TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Text(
                                    "${DateTime.now().hour - lastStatusTime.hour < 0 ? "Yesterday " : ""}${DateFormat.Hm().format(lastStatusTime)}", style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }
                            else{
                              return const Loader();
                            }
                          }
                        );
                      },
                    ),
                  );
                }
                return const Loader();
              }
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70, right: 10),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: (){
            Navigator.pushNamed(context, "/add-text-status");
          },
          child: Ink(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: searchBarColor
            ),
            child: const Icon(
              Icons.edit,
            ),
          ),
        ),
      ),
    );
  }
}
