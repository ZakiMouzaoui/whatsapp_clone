import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/models/user_model.dart';


final authControllerProvider = Provider((ref){
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final FutureProvider<UserModel?> userProvider  = FutureProvider<UserModel?>((ref){
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController{
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref
  });

  Future<UserModel?> getUserData()async{
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Future signInWithPhone(BuildContext context, String phoneNumber)async{
    await authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String otp){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: otp);
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic){
    authRepository.saveUserDataToFirebaseBase(context: context, name: name, profilePic: profilePic, ref: ref);
  }

  Stream<UserModel> userDataById(String id){
    return authRepository.userData(id);
  }
}
