import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controllers/select_contact_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/repository/select_contact_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return RefreshIndicator(
      onRefresh: ()async{
        ref.watch(selectContactRepositoryProvider).getWhatsappContacts();

      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select contact"),
              StreamBuilder<List<dynamic>>(
                stream: ref.read(selectContactController).getWhatsappContacts(),
                  builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Text("${snapshot.data![0].length} contact(s)", style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14
                    ),);
                  }
                  return Container();
                  }),
            ],
          ),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, "/new-group");
                  },
                  leading: const CircleAvatar(
                    backgroundColor: tabColor,
                    radius: 22,
                    child: Icon(Icons.group_rounded, color: Colors.white,),
                  ),
                  title: const Text("New group", style: TextStyle(fontWeight: FontWeight.w500),),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tabColor,
                    radius: 22,
                    child: Icon(Icons.person_add_rounded, color: Colors.white,),
                  ),
                  title: Text("New contact", style: TextStyle(fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.qr_code_rounded, color: Colors.grey,),
                ),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Contacts on whatsapp", style: TextStyle(color: Colors.grey),),
                ),
                const SizedBox(height: 10,),
                StreamBuilder<List<dynamic>>(
                      stream: ref.read(selectContactController).getWhatsappContacts(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Loader();
                        }
                        else if(snapshot.hasData){
                          final data = snapshot.data![0];
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (_, index){
                                final contact = UserModel.fromJson(data[index].data() as Map<String, dynamic>);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: ListTile(
                                    onTap: (){
                                      ref.read(selectContactController).selectContact(contact, context);
                                    },
                                    title: Text(contact.name.capitalize!,style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                    ),),
                                    leading: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                        contact.profilePic,
                                      ),
                                      radius: 22,
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
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Contacts on whatsapp", style: TextStyle(color: Colors.grey),),
                ),
                // NON WHATSAPP CONTACTS
                StreamBuilder<List<dynamic>>(
                  stream: ref.read(selectContactController).getWhatsappContacts(),
                  builder: (_, snapshot){
                    if(snapshot.hasData){
                      final data = snapshot.data![1];
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (_, index){
                            final contact = data[index] as Contact;
                            return Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: ListTile(
                                onTap: (){

                                },
                                title: Text(contact.displayName.capitalize!,style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                ),),
                                leading: CircleAvatar(
                                  backgroundImage: data[index].photo != null
                                      ? MemoryImage(
                                      contact.photo!
                                  ) : const CachedNetworkImageProvider("https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png") as ImageProvider,
                                  radius: 22,
                                ),
                                trailing: const Text("INVITE", style: TextStyle(
                                    color: tabColor,
                                    letterSpacing: 2
                                ),),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return Container();
                        },
                      );
                    }
                    return const Loader();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
