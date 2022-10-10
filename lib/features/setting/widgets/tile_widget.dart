import 'package:flutter/material.dart';

class SettingTileWidget extends StatelessWidget {
  const SettingTileWidget({Key? key, required this.icon, required this.title, required this.subtitle}) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey,),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey),),
    );
  }
}
