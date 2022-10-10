import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';

class MessageController extends GetxController{
  List<String> selectedMessages = [];
  int selectedCount = 0;

  selectMessage(String messageId){
    if(selectedMessages.contains(messageId)){
      selectedMessages.remove(messageId);
      selectedCount -= 1;
    }
    else{
      selectedMessages.add(messageId);
      selectedCount += 1;
    }
    update();
  }

  void deleteMessages(ProviderRef ref, List<String> messagesIds, String chatId){
    ref.read(chatRepositoryProvider).deleteChatMessages(messagesIds, chatId);
  }

  void reset(){
    selectedCount = 0;
    selectedMessages.clear();
    update();
  }
}
