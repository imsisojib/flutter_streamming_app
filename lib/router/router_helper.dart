import 'package:fluro/fluro.dart';
import 'package:flutter_streaming_app/router/routes.dart';
import 'package:flutter_streaming_app/screens/audio_player_screen.dart';
import 'package:flutter_streaming_app/screens/home_screen.dart';
import 'package:flutter_streaming_app/screens/page_not_found_screen.dart';


class RouterHelper {
  static final FluroRouter router = FluroRouter();

  ///Handlers
  static final Handler _homeScreenHandler =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const HomeScreen();
  });

  static final Handler _audioPlayerScreen =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const AudioPlayerScreen();
  });


  static final Handler _notFoundHandler =
  Handler(handlerFunc: (context, parameters) => const PageNotFoundScreen());

  void setupRouter() {
    router.notFoundHandler = _notFoundHandler;

    router.define(Routes.homeScreen,
        handler: _homeScreenHandler, transitionType: TransitionType.fadeIn);

    router.define(Routes.audioPlayer,
        handler: _audioPlayerScreen, transitionType: TransitionType.fadeIn);

  }

}
