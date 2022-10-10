import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/camera/screens/camera_screen.dart';
import 'package:whatsapp_clone/features/camera/screens/image_preview_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/chat_screen.dart';
import 'package:whatsapp_clone/features/group/screen/add_group_screen.dart';
import 'package:whatsapp_clone/features/group/screen/group_chat_screen.dart';
import 'package:whatsapp_clone/features/group/screen/new_group_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/setting/screen/setting_screen.dart';
import 'package:whatsapp_clone/features/status/screens/add_text_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/my_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_view_screen.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import 'features/camera/screens/video_preview_screen.dart';
import 'models/status.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name){
    case "/login":
      return MaterialPageRoute(builder: (_)=>const LoginScreen());
    case "/otp":
      return MaterialPageRoute(builder: (_)=>OTPScreen(verificationId: settings.arguments as String,));
    case "/user-info":
      return MaterialPageRoute(builder: (_)=>const UserInformationScreen());
    case "/select-contact":
      return MaterialPageRoute(builder: (_)=>const SelectContactsScreen());
    case "/chat":
      final chatModel = settings.arguments as ChatModel;
      return MaterialPageRoute(builder: (_)=>ChatScreen(chatModel: chatModel,));
    case "/add-text-status":
      return MaterialPageRoute(builder: (_)=>AddTextStatusScreen());
    case "/view-status":
      final storyItems = (settings.arguments as Map<String, dynamic>)["storyItems"] as List<StoryItem>;
      final uid = (settings.arguments as Map<String, dynamic>)["uid"];
      final statusDocs = (settings.arguments as Map<String, dynamic>)["statusDocs"];
      return MaterialPageRoute(builder: (_)=>StatusViewScreen(
          storyItems: storyItems,
          uid: uid,
          statusDocs: statusDocs,
      ));
    case "/image-preview":
      final path = (settings.arguments as Map<String, dynamic>)["path"];
      return MaterialPageRoute(builder: (_)=>ImagePreviewScreen(path: path));
    case "/video-preview":
      final path = (settings.arguments as Map<String, dynamic>)["path"];
      return MaterialPageRoute(builder: (_)=>VideoPreviewScreen(path: path));
    case "/camera":
      return MaterialPageRoute(builder: (_)=>const CameraScreen());
    case "/my-status":
      final status = (settings.arguments as Map<String, dynamic>)["status"];
      return MaterialPageRoute(builder: (_)=>MyStatusScreen(status: status,));
    case "/setting":
      final name = (settings.arguments as Map<String, dynamic>)["name"];
      final profilePic = (settings.arguments as Map<String, dynamic>)["profilePic"];
      return MaterialPageRoute(builder: (_)=>SettingScreen(
        name: name,
        profilePic: profilePic,
      ));
    case "/new-group":
      return MaterialPageRoute(builder: (_)=>const NewGroupScreen());
    case "/add-group":
      final contacts = (settings.arguments as Map<String, dynamic>)["contacts"];
      return MaterialPageRoute(builder: (_)=>AddGroupScreen(
        contacts: contacts,
      ));
    case "/group-chat":
      final chatModel = (settings.arguments as Map<String, dynamic>)["chatModel"];
      return MaterialPageRoute(builder: (_)=>GroupChatScreen(
        chatModel: chatModel,
      ));
    default:
      return MaterialPageRoute(builder: (_)=>const Scaffold(
        body: ErrorScreen(error: "Page not found",),
      ));
  }
}
