import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider((ref)=> AuthRepository(
    fireStore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance)
);

class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRepository({
    required this.auth,
    required this.fireStore
  });

  Future<UserModel?> getCurrentUserData()async{
    var userData = await fireStore.collection("users").doc(auth.currentUser?.uid).get();
    UserModel? userModel;

    if(userData.data() != null){
      userModel = UserModel.fromJson(userData.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  Future signInWithPhone(BuildContext context, String phoneNumber) async{
    try{
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential)async{
            await auth.signInWithCredential(phoneAuthCredential);
          },

          verificationFailed: (FirebaseAuthException exception){
            throw Exception(exception.message);
          },
          codeSent: (String verificationId, int? resendToken)async{
            Navigator.pushNamed(context, "/otp", arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String authVerificationId){

          }
      );
    }
    on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message.toString());
    }
  }

  void verifyOTP({required BuildContext context, required String verificationId, required String userOTP})async{
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(context, "/user-info", (route)=>false);
    }
    on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message.toString());

    }
  }

  void saveUserDataToFirebaseBase({
    required BuildContext context,
    required String name,
    required File? profilePic,
    required ProviderRef ref
  }) async{
    try{
      String uid = auth.currentUser!.uid;
      String photo = photoUrl;

      if(profilePic != null){
        photo = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase("ProfilePics/$uid", profilePic);
      }
      UserModel userModel = UserModel(
          uid: uid,
          name: name,
          profilePic: photo,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupIds: []
      );
      await fireStore.collection("users").doc(uid).set(userModel.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=>MobileScreenLayout(profilePic: photo, uid: uid,)),
          (route) => false);
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId){
    return fireStore.collection("users").doc(userId).snapshots().map((snapshot){
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  void setUserStatus(bool isOnline)async{
    await fireStore.collection("users").doc(auth.currentUser!.uid).update({
      "isOnline": isOnline
    });
  }
}
