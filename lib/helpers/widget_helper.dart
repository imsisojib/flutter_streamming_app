import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_streaming_app/widgets/buttons/button_filled.dart';


class WidgetHelper{
  static Future<void> showAlertDialog(BuildContext context, String? title, String? body, {Function? function, String? buttonText}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.h),
          ),
          title: Text(title??"",softWrap: true,textAlign: TextAlign.start,),
          content: Text(body??"", style: Theme.of(context).textTheme.bodyText2,textAlign: TextAlign.start,),
          actions: <Widget>[
            ButtonFilled(
              buttonText: buttonText??"Ok",
              function: () {
                Navigator.pop(context);
                function?.call();
              },
            )
          ],
        );
      },
    );
  }
}