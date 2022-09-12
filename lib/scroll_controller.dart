import 'package:get/get.dart';

class MyScrollController extends GetxController{
  bool showBtn = false;

  void toggleBtn(bool value){
    showBtn = value;
    update();
  }


  @override
  void onClose() {
    showBtn = false;
    super.onClose();
  }
}