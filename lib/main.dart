import 'package:flutter/material.dart';
import 'package:flutter_streaming_app/providers/app_provider.dart';
import 'package:flutter_streaming_app/providers/music_provider.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'streaming_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();  //initializing Dependency Injection

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AppProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<MusicProvider>()),
      ],
      child: const StreamingApp(),
    ),
  );
}
