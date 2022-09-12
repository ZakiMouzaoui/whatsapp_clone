import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            const Text("Welcome to whatsapp", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
            ),),
            SizedBox(height: size.height/22,),
            const Image(image: AssetImage(
              "assets/bg.png",
            ),
            color: messageColor,
            height: 340,
            width: 340,),
            SizedBox(height: size.height/22,),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Read our privacy policy. Tap "Agree and continue" to accept the terms of service',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width*0.75,
              child: CustomButton(text: "AGREE AND CONTINUE", onPressed: (){
                Navigator.of(context).pushNamed('/login');
              }),
            )
          ],
        ),
      ),
    );
  }
}
