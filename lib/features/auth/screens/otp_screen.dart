import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  final String verificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    void verifyOTP(BuildContext context, String otp){
      ref.read(authControllerProvider).verifyOTP(context, verificationId, otp);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying your phone number"),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              "We have sent you an SMS with a verification code"
            ),
            SizedBox(width: size.width*0.5,child:TextField(
              textAlign: TextAlign.center,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: "- - - - - - ",
                counterText: "",
                hintStyle: TextStyle(
                  fontSize: 30,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: tabColor
                  )
                ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: tabColor
                      )
                  )
              ),
              keyboardType: TextInputType.number,
              onChanged: (value){
                if(value.trim().length == 6){
                  verifyOTP(context, value);
                }
              },
              cursorColor: tabColor,

            ),)
          ],
        ),
      )
    );
  }
}
