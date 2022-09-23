import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_streaming_app/resources/app_themes.dart';
import 'package:flutter_streaming_app/router/router_helper.dart';
import 'package:flutter_streaming_app/router/routes.dart';


class StreamingApp extends StatefulWidget{
  const StreamingApp({Key? key}) : super(key: key);

  @override
  State<StreamingApp> createState() => _StreamingAppState();
}

class _StreamingAppState extends State<StreamingApp> {

  @override
  void initState() {
    super.initState();

    RouterHelper().setupRouter();

  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, app) {
        return MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              //Removes the whole app's scroll glow
              behavior: AppBehavior(),
              child: child!,
            );
          },
          title: 'Streaming App',
          themeMode: ThemeMode.dark,
          theme: buildDarkTheme(context),
          initialRoute: Routes.homeScreen,
          onGenerateRoute: RouterHelper.router.generator,
        );
      },
    );
  }
}

//to avoid scroll glow in whole app
class AppBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) {
    return child;
  }
}