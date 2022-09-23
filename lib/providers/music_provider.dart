import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicProvider extends ChangeNotifier{

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  //states
  List<SongModel> _songs = [];
  bool _loadingAudioPlayer = true;
  int _currentIndex = 0;
  Uint8List? _songCoverPhoto;

  //getters
  List<SongModel> get songs => _songs;
  bool get loadingAudioPlayer => _loadingAudioPlayer;
  int get currentIndex => _currentIndex;
  Uint8List? get songCoverPhoto => _songCoverPhoto;

  //setters
  set loadingAudioPlayer(bool flag){
    _loadingAudioPlayer = flag;
    notifyListeners();
  }

  set currentIndex(int index){
    _currentIndex = index;
    updateCoverPhoto();
    notifyListeners();
  }

  updateCoverPhoto()async{
    _songCoverPhoto =  await audioQuery.queryArtwork(
      songs[_currentIndex].id,
      ArtworkType.AUDIO,
    );
    notifyListeners();
  }

  void readAudioMusicFromLocal()async{

    _songs = await audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
    );
    notifyListeners();
  }

  Future<Uint8List?> loadSongCoverPhoto(int songId)async{
    return await audioQuery.queryArtwork(
      songId,
      ArtworkType.AUDIO,
    );
  }

  void initAudioPlayer()async{
    updateCoverPhoto();
    loadingAudioPlayer = true;
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: songs.map((song) => AudioSource.uri(Uri.parse(song.uri!))).toList(),
    );

    await audioPlayer.setAudioSource(playlist, initialIndex: _currentIndex, initialPosition: Duration.zero);
    await audioPlayer.setShuffleModeEnabled(false);

    loadingAudioPlayer = false;
  }

  void playNext() async{
    if(_currentIndex<songs.length-1){
      currentIndex = _currentIndex++;
      await audioPlayer.seekToNext();
      updateCoverPhoto();
    }
  }
  void playPrevious() async{
    if(_currentIndex>0){
      currentIndex = _currentIndex--;
      await audioPlayer.seekToPrevious();
      updateCoverPhoto();
    }


  }

  void removeSong(int index) {
    try{
      _songs.removeAt(index);
      notifyListeners();
    }catch(e){
      print(e);
    }
  }


}