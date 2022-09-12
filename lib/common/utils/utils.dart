import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';

void showSnackBar({required BuildContext context, required String content}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
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