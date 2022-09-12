import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerItem extends StatefulWidget {
  const AudioPlayerItem({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<AudioPlayerItem> createState() => _AudioPlayerItemState();
}

class _AudioPlayerItemState extends State<AudioPlayerItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late Stream<Duration?> durationStream = _audioPlayer.onDurationChanged;
  late Stream<Duration> positionStream = _audioPlayer.onPositionChanged;
  double duration = 0;

  @override
  void initState(){
    initAudioPlayer();
    durationStream.listen((event) {
      duration = event!.inMicroseconds.toDouble();
    });

    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void initAudioPlayer()async{
    await _audioPlayer.dispose();
    await _audioPlayer.setSourceUrl(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              child: Icon(_audioPlayer.state == PlayerState.playing ? Icons.pause : Icons.play_arrow, color: Colors.grey,),
              onTap: ()async{
                if(_audioPlayer.state == PlayerState.playing){
                  await _audioPlayer.pause();
                }
                else{
                  await _audioPlayer.resume();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(data: SliderThemeData(
                inactiveTrackColor: Colors.grey,
                  overlayShape: SliderComponentShape.noOverlay
              ), child: StreamBuilder<Duration>(
                stream: positionStream,
                builder: (context, snapshot) {
                  return Slider(
                    value: snapshot.hasData ? snapshot.data!.inMicroseconds.toDouble() : Duration.zero.inMicroseconds.toDouble(),
                    min: 0,
                    max: duration,
                    onChanged: (value){
                    },
                  );
                }
              )),
              const SizedBox(height: 3,),
              StreamBuilder<Duration?>(
                  stream: durationStream,
                  builder: (_, snapshot)=>Text(snapshot.hasData ? snapshot.data.toString().split('.')[0] : "")
              )
            ],
          )
        ],
      ),
    );
  }
}
