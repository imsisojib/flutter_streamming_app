import 'package:flutter_streaming_app/providers/app_provider.dart';
import 'package:flutter_streaming_app/providers/music_provider.dart';
import 'package:flutter_streaming_app/repositories/cache_repository.dart';
import 'package:flutter_streaming_app/repositories/token_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //using dependency-injection
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //repositories
  sl.registerLazySingleton(() => CacheRepository(sharedPreferences: sl()));

  //providers
  sl.registerFactory(() => AppProvider(cacheRepository: sl()));
  sl.registerFactory(() => MusicProvider());

  //token manager
  TokenRepository tokenManager = TokenRepository();
  sl.registerSingleton(tokenManager);

}
