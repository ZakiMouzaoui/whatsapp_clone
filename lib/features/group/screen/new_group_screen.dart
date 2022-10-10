import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/group/controller/add_contact_controller.dart';

class NewGroupScreen extends ConsumerStatefulWidget {
  const NewGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<NewGroupScreen> {
  final addContactController = Get.put(AddContactController());
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(addContactController.searching){
          addContactController.changeSearchState(false);
          return false;
        }
        addContactController.clearSelected();
        return true;
      },
      child: GetBuilder<AddContactController>(
          builder: (_) => Scaffold(
          appBar: AppBar(
            title: addContactController.searching ? TextField(
              onChanged: (value){
                addContactController.filter(value.trim());
              },
              cursorHeight: 30,
              autofocus: true,
              controller: searchController,
              cursorColor: tabColor,
              decoration: const InputDecoration(
                hintText: "Search ...",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.none
                  )
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.none
                    )
                ),
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("New group"),
                Text(addContactController.selectedCount == 0
                  ? "add participants" : "${addContactController.selectedCount} of 512 selected", style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal
                ),),
              ],
            ),
            actions: [
              !addContactController.searching ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    addContactController.changeSearchState(true);
                  },
                    child: const Icon(Icons.search_rounded)),
              ) : Container()
            ],

          ),
          body: Column(
            children: [
              addContactController.selectedCount > 0
              ? Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      itemCount: addContactController.selectedCount,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index){
                        final contact = addContactController.selected[index];
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            width: 70,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: tabColor,
                                  backgroundImage: contact.photo != null
                                        ? MemoryImage(contact.photo!) as ImageProvider
                                        : const CachedNetworkImageProvider("https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png"),
                                  radius: 25,
                                ),
                                const SizedBox(height: 5,),
                                Text(contact.displayName, overflow: TextOverflow.ellipsis, style: const TextStyle(
                                  color: Colors.grey
                                ),)
                              ],
                            ),
                          ),
                          Positioned(
                                bottom: 20,
                                left: 40,
                                child: GestureDetector(
                                  onTap: (){
                                    addContactController.removeContact(index);
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.close_rounded, color: Colors.black, size: 18,)
                            ),
                                ),),
                        ],
                      );
                    }),
                  ),
                  const Divider()
                ],
              ) : Container(),
              Expanded(
                child: addContactController.found.isNotEmpty ? ListView.builder(
                          itemCount: addContactController.found.length,
                          itemBuilder: (_, index){
                            final contact = addContactController.found[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom:10.0),
                              child: Stack(
                                children: [
                                  ListTile(
                                    onTap: (){
                                      addContactController.addContact(index);
                                      if(searchController.text.isNotEmpty){
                                        searchController.clear();
                                        addContactController.resetSearch();
                                      }
                                    },
                                    title: Text(contact.displayName,style: const TextStyle(
                                        fontSize: 17
                                    ),),
                                    leading:
                                    CircleAvatar(
                                      backgroundImage: contact.photo != null
                                          ? MemoryImage(contact.photo!) as ImageProvider
                                          : const CachedNetworkImageProvider("https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png"),
                                      backgroundColor: tabColor,
                                      radius: 22,
                                    ),
                                  ),
                                  addContactController.selected.indexWhere((element) => element.phones == contact.phones) != -1
                                  ? const Positioned(
                                    bottom: 0,
                                    left: 40,
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: tabColor,
                                      child: Icon(Icons.check, color: Colors.black87, size: 18,),
                                    ),
                                  ) : Container()
                                ],
                              )

                            );
                          },
                        ) : const Center(child: Text("No contact found"),),
              ),
            ],
          ),
            floatingActionButton: AnimatedOpacity(
              curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500), opacity: addContactController.selectedCount > 0 ? 1 : 0,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/add-group", arguments: {
                      "contacts": addContactController.selected
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: tabColor,
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ),
                ),
              ),
            )
      ),
    );
  }
}
