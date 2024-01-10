import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/my_widgets.dart';
import '../utils/utils.dart';

class ShowCustomDialog extends StatefulWidget {
  final Widget body;
  final Widget? closeBtn;
  final Duration? animationTime;
  final double? height;
  final double? width;
  final Color? bgColor;

  const ShowCustomDialog(this.body, {super.key, this.closeBtn, this.animationTime, this.height, this.width, this.bgColor});

  @override
  State<StatefulWidget> createState() => ShowCustomDialogState();
}

class ShowCustomDialogState extends State<ShowCustomDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  bool isCanceling = false;

  bool isRescheduling = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.animationTime??Static.dialogAnimationDuration??0.milliseconds);
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticOut);
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
          child: Container(
            height: widget.height??Get.height * 0.9,
            width: widget.width??Get.width * 0.8,
            // padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            decoration: pBoxDecoration(
              radius: 8.0,
              color: widget.bgColor??Static.webDialogBgColor??Clr.colorWhite,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.closeBtn??IconButton(onPressed: ()=> Get.back(result: false), icon: const Icon(Icons.close))
                  ],
                ),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
