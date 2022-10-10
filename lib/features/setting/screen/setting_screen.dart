import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/setting/widgets/tile_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key, required this.name, required this.profilePic}) : super(key: key);
  final String name;
  final String profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: tabColor,
              backgroundImage: CachedNetworkImageProvider(
                profilePic
              ),
              radius: 30,
            ),
            title: Text(name),
            subtitle: const Text("Sleeping"),
            trailing: const Icon(Icons.qr_code_rounded, color: tabColor,),
          ),
          const Divider(thickness: 2,),
          const SettingTileWidget(icon: Icons.key_outlined, title: "Account", subtitle: "Privacy, security, change number"),
          const SettingTileWidget(icon: Icons.message_rounded, title: "Chats", subtitle: "Theme, wallpaper, chat history"),
          const SettingTileWidget(icon: Icons.notifications_rounded, title: "Notifications", subtitle: "Message, group & call tones"),
          const SettingTileWidget(icon: Icons.data_usage_rounded, title: "Data usage", subtitle: "Network usage, auto-download"),
          const SettingTileWidget(icon: Icons.language_rounded, title: "App language", subtitle: "English"),
          const SettingTileWidget(icon: Icons.help_outline_rounded, title: "Help", subtitle: "Help center, contact us, privacy policy")
        ],
      )
    );
  }
}
