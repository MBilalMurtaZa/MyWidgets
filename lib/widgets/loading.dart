import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class LoadingPro extends StatelessWidget {
  final double? size;
  final bool isLinear;
  final Color? valueColor, backgroundColor;
  const LoadingPro(
      {this.size,
        this.isLinear = false,
        this.valueColor,
        this.backgroundColor,
        Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      padding: EdgeInsets.all(5),
      child: Center(
        child: isLinear
            ? LinearProgressIndicator(
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
              valueColor ?? Clr.colorPrimary),
        )
            : Platform.isAndroid
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              valueColor ?? Clr.colorPrimary),
        )
            : CircleAvatar(
          backgroundColor: backgroundColor ?? Clr.colorWhite,
          child: CupertinoActivityIndicator(
            color: valueColor ?? Clr.colorPrimary,
          ),
        ),

//      child: LinearProgressIndicator(),
      ),
    );
  }
}
