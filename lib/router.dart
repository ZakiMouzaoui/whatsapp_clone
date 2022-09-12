import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/chat_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/status/screens/add_text_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_view_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';

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
      final arguments = settings.arguments as UserModel;
      return MaterialPageRoute(builder: (_)=>ChatScreen(userModel: arguments,));
    case "/add-text-status":
      return MaterialPageRoute(builder: (_)=>AddTextStatusScreen());
    case "/view-status":
      return MaterialPageRoute(builder: (_)=>StatusViewScreen(storyItems: settings.arguments as List<StoryItem>));
    default:
      return MaterialPageRoute(builder: (_)=>const Scaffold(
        body: ErrorScreen(error: "Page not found",),
      ));
  }
}
