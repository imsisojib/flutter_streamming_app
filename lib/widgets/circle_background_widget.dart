import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleBackgroundWidget extends StatelessWidget{
  final Widget child;

  const CircleBackgroundWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      width: 90.h,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: child,
      ),
    );
  }
}