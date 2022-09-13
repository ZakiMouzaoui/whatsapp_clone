import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/status_contact.dart';

class ContactStatusScreen extends ConsumerWidget {
  const ContactStatusScreen({Key? key, required this.profilePic, required this.uid}) : super(key: key);
  final String profilePic;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: (){

              },
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      profilePic,
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
            FutureBuilder<List<StatusContact>>(
              future: ref.watch(statusRepositoryProvider).getStatus(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_,index){
                        final statusContact = snapshot.data![index];
                        final statuses = statusContact.statuses;
                        return ListTile(
                          onTap: (){
                            List<StoryItem> storyItems = [];
                            for(final status in statuses){
                              storyItems.add(StoryItem.text(title: status.statusContent, backgroundColor: Colors.grey[400]!));
                            }
                            Navigator.pushNamed(context, "/view-status", arguments: storyItems);
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    statuses.last.profilePic
                                ),
                                radius: 25,
                              ),
                              Container(
                                width: 50,
                                height:50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: statuses.first.uid == uid ? Colors.grey : tabColor,width: 2.5)
                                ),
                              )
                            ],
                          ),
                          title: Text(statuses.first.uid == uid ? "My status" : statuses.first.userName, style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(DateFormat.Hm().format(statusContact.lastStatusTime), style: const TextStyle(color: Colors.grey),),
                        );
                      },
                    ),
                  );
                }
                return const Loader();
              }
            )
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
