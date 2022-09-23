import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_streaming_app/providers/music_provider.dart';
import 'package:flutter_streaming_app/resources/app_images.dart';
import 'package:flutter_streaming_app/router/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchSongs();
    });

  }

  void fetchSongs()async{
    if (await Permission.storage.request().isGranted) {
      Provider.of<MusicProvider>(context,listen: false).readAudioMusicFromLocal();
    }
    if(await Permission.storage.isPermanentlyDenied){
      openAppSettings();
    }

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<MusicProvider>(builder: (_,musicProvider,child){
      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: ()async{
              if (await Permission.storage.request().isGranted) {
                Provider.of<MusicProvider>(context,listen: false).readAudioMusicFromLocal();
              }
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  expandedHeight: 270.h,
                  flexibleSpace: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(AppImages.cover_photo),
                      Padding(
                        padding: EdgeInsets.fromLTRB(26.w, 26.h, 47.w, 30.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Peaceful Piano Music",style: theme.textTheme.headline4,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                                Text("Instrumental",style: theme.textTheme.caption?.copyWith(fontWeight: FontWeight.normal,color: theme.colorScheme.onBackground.withOpacity(.5),),),
                                SizedBox(width: 7.w,),
                                SizedBox(height: 3,width:3,child: CircleAvatar(backgroundColor: theme.colorScheme.onBackground.withOpacity(.5),)),
                                SizedBox(width: 7.w,),
                                Text("${musicProvider.songs.length} songs",style: theme.textTheme.caption?.copyWith(fontWeight: FontWeight.normal,color: theme.colorScheme.onBackground.withOpacity(.5)),),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 30.h,),
                ),
                SliverList(delegate: SliverChildBuilderDelegate(
                    (_,index){
                      return InkWell(
                        onTap: (){
                          musicProvider.currentIndex = index;
                          Navigator.pushNamed(context, Routes.audioPlayer);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(26.w, 0, 26.w, 11.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.h),
                                child: Container(
                                  height: 75.h,
                                  width: 75.h,
                                  child: FutureBuilder(
                                    future: musicProvider.loadSongCoverPhoto(musicProvider.songs[index].id),
                                    builder: (_,AsyncSnapshot response){
                                      if(response.hasData){
                                        Uint8List? imageData = response.data;
                                        if(imageData!=null){
                                          return Image.memory(imageData,fit: BoxFit.cover,);
                                        }
                                      }

                                      return Container(height: 75.h,width: 75.h,color: theme.colorScheme.surface,);
                                    },
                                  ),

                                ),
                              ),
                              SizedBox(width: 19.w,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(musicProvider.songs[index].title,style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  Text(musicProvider.songs[index].displayName,style: theme.textTheme.bodyText2?.copyWith(color: theme.textTheme.bodyText2?.color?.withOpacity(.5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                ],
                              ),),
                              IconButton(onPressed: (){
                                musicProvider.removeSong(index);
                              }, icon: Icon(
                                  Icons.clear
                              ),),
                            ],
                          ),
                        ),
                      );
                    },
                  childCount: musicProvider.songs.length,
                ),),
              ],
            ),
          )
        ),
      );
    },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}