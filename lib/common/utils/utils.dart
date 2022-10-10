import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';

void showSnackBar({required BuildContext context, required String content}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content,style: const TextStyle(color: Colors.white),),backgroundColor: searchBarColor,)
  );
}


Future<File?> pickImage(BuildContext context)async{
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedImage != null){
      image = File(pickedImage.path);
    }
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> openCamera(BuildContext context)async{
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(pickedImage != null){
      image = File(pickedImage.path);
    }
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideo(BuildContext context)async{
  File? video;
  try{
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if(pickedVideo != null){
      video = File(pickedVideo.path);
    }

    return video;
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context)async{
  GiphyGif? gif;
  try{
    gif = await Giphy.getGif(context: context, apiKey: "pCDSCtSFrZ5v5sK9Cl2lqzJpEkrdJhz1");
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}


const photoUrl = "https://media.cntraveler.com/photos/60596b398f4452dac88c59f8/"
    "16:9/w_3999,h_2249,c_limit/MtFuji-GettyImages-959111140.jpg";

Future<String> storeFileToFirebase(String ref, File file)async{
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

void showLoadingDialog(context){
  showDialog(
      context: context,
      builder: (_)=>AlertDialog(
        backgroundColor: searchBarColor,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Loader(),
                  SizedBox(width: 10,),
                  Text(
                    "Please wait ...",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
  );
}