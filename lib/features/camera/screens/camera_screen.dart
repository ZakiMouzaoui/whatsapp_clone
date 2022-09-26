import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController controller;
  int index = 0;
  double zoom = 1.0;
  bool isFlash = false;
  bool isRecording = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera(index);
    }
  }

  @override
  void initState() {
    initCamera(index);
    super.initState();
  }

  Future initCamera(int index) async {
    controller = CameraController(cameras[index], ResolutionPreset.max);

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void takePicture() async {
    final pic = await controller.takePicture();
    navigateToImagePreviewScreen(pic);
  }

  void navigateToImagePreviewScreen(XFile image){
    Navigator.pushNamed(context, "/image-preview", arguments: {
      "path": image.path
    });
  }

  void navigateToVideoPreviewScreen(XFile video){
    Navigator.pushNamed(context, "/video-preview", arguments: {
      "path": video.path
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        body: Stack(
      children: [
        GestureDetector(
          onTap: (){
            controller.setFocusMode(FocusMode.auto);
          },
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: CameraPreview(
              controller,
            ),
          )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      focusColor: tabColor,
                      borderRadius: BorderRadius.circular(30),
                      splashColor: tabColor,
                      onTap: () {
                        setState(() {
                          isFlash = !isFlash;
                        });
                        if(!isFlash){
                          controller.setFlashMode(FlashMode.off);
                        }
                        else{
                          controller.setFlashMode(FlashMode.always);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(isFlash ? Icons.flash_on : Icons.flash_off),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: ()async{
                        await controller.startVideoRecording();
                        setState(() {
                          isRecording = true;
                        });
                      },
                      onLongPressEnd: (detail)async{
                        final video = await controller.stopVideoRecording();
                        navigateToVideoPreviewScreen(video);
                        setState(() {
                          isRecording = false;
                        });
                      },
                      onTap: () {
                        takePicture();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: !isRecording ?
                        const Icon(Icons.panorama_fish_eye, size: 60,)
                            : const Icon(Icons.radio_button_on_outlined, color: Colors.red, size: 70,)
                      ),
                    ),
                    InkWell(
                        splashColor: tabColor,
                        borderRadius: BorderRadius.circular(30),
                          onTap: () {
                              index == 0 ? index = 1 : index = 0;
                              initCamera(index);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.flip_camera_ios_sharp),
                          )),
                  ],
                ),
                isRecording ? Container() : const Text("Tap for photo, hold for video")
              ],
            ),
          ),
        )
      ],
    ));
  }
}
