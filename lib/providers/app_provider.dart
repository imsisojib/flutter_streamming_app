import 'package:flutter/cupertino.dart';
import 'package:flutter_streaming_app/repositories/cache_repository.dart';

class AppProvider extends ChangeNotifier{
  final CacheRepository cacheRepository;
  AppProvider({required this.cacheRepository});
}