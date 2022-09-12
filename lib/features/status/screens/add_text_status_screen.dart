import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/status/controller/add_status_controller.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';

class AddTextStatusScreen extends ConsumerWidget {
  AddTextStatusScreen({Key? key}) : super(key: key);

  final addStatusController = Get.put(AddStatusController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: GetBuilder<AddStatusController>(
        builder: (_) => WillPopScope(
          onWillPop: ()async{
            addStatusController.textController.clear();
            return true;
          },
          child: Scaffold(
          body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: addStatusController.colors.values.elementAt(addStatusController.index),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              GestureDetector(onTap: (){
                                addStatusController.changeColor();
                              },child: const Icon(Icons.palette))
                            ],
                          ),
                        ),
                        //SizedBox(height: MediaQuery.of(context).size.height/1.7,),
                        const Expanded(child: SizedBox()),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value){
                                addStatusController.changeSendBtnStatus(value.isNotEmpty);
                              },
                              controller: addStatusController.textController,
                              scrollPadding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height),
                              autofocus: true,
                              textAlign: TextAlign.center,
                              maxLines: null,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 33,
                              ),
                              cursorColor: Colors.white,
                              cursorHeight: 50,
                              decoration: InputDecoration(
                                hintText: "Write a status",
                                hintStyle: TextStyle(
                                    fontSize: 33,
                                    color: addStatusController.colors.values.elementAt(addStatusController.index)[250]
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                    )
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,

                                    )
                                ),
                              ),
                            ),
                          ),
                        const Expanded(child: SizedBox()),
                        Container(
                          padding: const EdgeInsets.all(8),
                            height: 60,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              //backgroundBlendMode: BlendMode.darken
                            ),
                          child: Visibility(
                            visible: addStatusController.showSendBtn,
                            child: GestureDetector(
                              onTap: (){
                                ref.read(statusControllerProvider).addTextStatus(addStatusController.textController.text);
                                showSnackBar(context: context, content: "Status added");
                                Navigator.pop(context);
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:tabColor
                                  ),
                                  child: const Icon(Icons.send),
                                ),
                              ),
                            ),
                          ),
                          ),

                      ],
                    ),
                  ),
          ),
        ),
        ),


    );
  }
}
