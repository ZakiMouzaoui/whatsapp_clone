import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStatusController extends GetxController{
  int index = 0;
  bool showSendBtn = false;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.clear();
    textController.dispose();
    super.dispose();
  }

  final colors = {
    "green": Colors.green,
    "red": Colors.red,
    "blue": Colors.blue,
    "yellow": Colors.yellow,
    "grey": Colors.grey
  };

  void changeColor(){
    if(index == colors.length-1){
      index = 0;
    }
    else{
      index += 1;
    }
    update();
  }

  void changeSendBtnStatus(bool state){
    showSendBtn = state;
    update();
  }
}
