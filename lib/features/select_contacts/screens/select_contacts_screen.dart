import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controllers/select_contact_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/repository/select_contact_repository.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return RefreshIndicator(
      onRefresh: ()async{
        ref.watch(selectContactRepositoryProvider).getContacts();

      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select contact"),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: StreamBuilder<List<Contact>>(
              stream: ref.read(selectContactController).getContacts(),
              builder: (context, snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Loader();
                }
                else if(snapshot.hasData){
                  final data = snapshot.data!;
                  return ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (_, index){
                      final contact = data[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: ListTile(
                          onTap: (){
                            ref.read(selectContactController).selectContact(contact, context);
                          },
                          title: Text(contact.displayName,style: const TextStyle(
                              fontSize: 18
                          ),),
                          leading: contact.photo == null ? null : CircleAvatar(
                            backgroundImage: MemoryImage(
                              contact.photo!,
                            ),
                            radius: 30,
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 1,);
                  },
                  );
                }
                return const ErrorScreen(error: "Couldn't load the contacts due to some error");
              }
        ),
      ),
    );
  }
}
