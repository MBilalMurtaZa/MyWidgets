import 'package:flutter/material.dart';

import '../utils/utils.dart';

class MyVerticalDivider extends StatelessWidget {
  final double width;
  final Color color;
  const MyVerticalDivider({this.width = Siz.standardPadding, this.color = Clr.colorTransparent, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(width: width,color: color,);
  }
}
class MyDivider extends StatelessWidget {
  final double height;
  final Color color;
  const MyDivider({this.height = Siz.standardPadding, this.color = Clr.colorTransparent, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(height: height,color: color,);
  }
}