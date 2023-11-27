import 'package:flutter/material.dart';

import '../utils/utils.dart';

class MyVerticalDivider extends StatelessWidget {
  final double width;
  final double? thickness;
  final Color color;
  const MyVerticalDivider(
      {this.width = Siz.standardPadding,
      this.color = Clr.colorTransparent,
        this.thickness,
      super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width,
      color: color,
      thickness: thickness,
    );
  }
}

class MyDivider extends StatelessWidget {
  final double height;
  final double? thickness;
  final Color color;

  const MyDivider(
      {this.height = Siz.standardPadding,
      this.color = Clr.colorTransparent,
        this.thickness,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color,
      thickness: thickness,
    );
  }
}
