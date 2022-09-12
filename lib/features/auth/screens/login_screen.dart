import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  String phoneCode = "";
  bool loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            phoneCode = country.phoneCode;
          });
        });
  }

  void sendPhoneNumber() async{
    String phoneNumber = "+$phoneCode${_phoneController.text.trim()}";

    setState(() {
      loading = true;
    });

    if (phoneCode.isNotEmpty && phoneNumber.isNotEmpty) {
      final authController = ref.read(authControllerProvider);
      authController.signInWithPhone(context, phoneNumber);
      await Future.delayed(const Duration(milliseconds: 1000)).then((value){
        setState(() {
          loading = false;
        });
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showSnackBar(context: context, content: "Please fill out all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Whatsapp, we need to verify your phone number"),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    pickCountry();
                  },
                  child: const Text("Pick country")),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(phoneCode.isEmpty ? "" : "+$phoneCode"),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      cursorColor: tabColor,
                      decoration: const InputDecoration(
                        hintText: "Phone number",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: tabColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: tabColor)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.55,
              ),
              loading
                  ? const CircularProgressIndicator(
                      color: tabColor,
                    )
                  : SizedBox(
                      width: 90,
                      child: CustomButton(
                        onPressed: () {
                          sendPhoneNumber();
                        },
                        text: "Next",
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
