// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains overlay loading.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/widgets/loading.dart';

import '../utils/utils.dart';

class OverlayLoadingDialog extends StatefulWidget {
  final Duration? animationTime;
  final Widget? body;

  const OverlayLoadingDialog({
    super.key,
    this.animationTime,
    this.body,
  });

  @override
  State<StatefulWidget> createState() => OverlayLoadingDialogState();
}

class OverlayLoadingDialogState extends State<OverlayLoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  bool isCanceling = false;

  bool isRescheduling = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: widget.animationTime ??
            Static.dialogAnimationDuration ??
            0.milliseconds);
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticOut);
    controller?.addListener(() {
      setState(() {});
    });

    controller?.forward();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Center(
            child: widget.body ??
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: LoadingPro(),
                ),
          ),
        ),
      ),
    );
  }
}
