import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';


class MyStatusScreen extends ConsumerStatefulWidget {
  const MyStatusScreen({Key? key, required this.status}) : super(key: key);

  final List<DocumentSnapshot> status;

  @override
  ConsumerState<MyStatusScreen> createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends ConsumerState<MyStatusScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My status"),
      ),
      body: ListView.builder(
        itemCount: widget.status.length,
          itemBuilder: (_, index){
          final statusModel = widget.status[index];
          final lastStatusTime = statusModel.get("createdAt").toDate();
        return ListTile(
          leading: const CircleAvatar(
            radius: 25,
          ),
          title: Text("${statusModel.get("seenBy").length} views"),
          subtitle: Text(
            "${DateTime.now().hour - lastStatusTime.hour < 0 ? "Yesterday " : ""}${DateFormat.Hm().format(lastStatusTime)}", style: const TextStyle(color: Colors.grey),
          ),
          trailing: InkWell(
              onTap: ()async{
                showDialog(context: context, builder: (_)=>AlertDialog(
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
                ));
                await ref.read(statusRepositoryProvider).deleteStatus(statusModel.id).then((_){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showSnackBar(context: context, content: "Status deleted");
                });
              },
              child: const Icon(Icons.delete_rounded, color: Colors.grey,)
          ),
        );
      }),
    );
  }
}
