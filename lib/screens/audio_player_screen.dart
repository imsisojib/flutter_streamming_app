import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_streaming_app/providers/music_provider.dart';
import 'package:flutter_streaming_app/widgets/circle_background_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MusicProvider>(context,listen: false).initAudioPlayer();
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<MusicProvider>(
      builder: (_,musicProvider,child){
        return musicProvider.loadingAudioPlayer?Scaffold(
          body: SafeArea(
            child: Center(child: CircularProgressIndicator(),),
          ),
        ):Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.h),
                    child: Container(
                      height: 321.h,
                      width: 281.w,
                      child: musicProvider.songCoverPhoto!=null?
                      Image.memory(musicProvider.songCoverPhoto!,fit: BoxFit.cover,):
                      Container(height: 321.h,width: 321.h,color: theme.colorScheme.surface,),

                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(musicProvider.songs[musicProvider.currentIndex].title,style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                      Text(musicProvider.songs[musicProvider.currentIndex].displayName,style: theme.textTheme.bodyText2?.copyWith(color: theme.textTheme.bodyText2?.color?.withOpacity(.5)),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                SizedBox(height: 16.h,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Opens volume slider dialog
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        musicProvider.playPrevious();
                      },
                    ),

                    StreamBuilder<PlayerState>(
                      stream: musicProvider.audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return CircleBackgroundWidget(
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 64.0,
                              height: 64.0,
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        } else if (playing != true) {
                          return CircleBackgroundWidget(child: IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.play_arrow),
                            iconSize: 64.0,
                            onPressed: musicProvider.audioPlayer.play,
                          ),);
                        } else if (processingState != ProcessingState.completed) {
                          return CircleBackgroundWidget(
                            child: IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 64.0,
                              onPressed: musicProvider.audioPlayer.pause,
                            ),
                          );
                        } else {
                          return CircleBackgroundWidget(
                            child: IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.replay),
                              iconSize: 64.0,
                              onPressed: () => musicProvider.audioPlayer.seek(Duration.zero),
                            ),
                          );
                        }
                      },
                    ),
                    // Opens speed slider dialog
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        musicProvider.playNext();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}