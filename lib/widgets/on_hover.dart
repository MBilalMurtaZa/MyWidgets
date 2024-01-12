import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:my_widgets/utils/utils.dart';

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered)? builder;
  final Widget? child;
  final Matrix4? hoveredMatrix4;
  final double? hoverScale;
  final Duration? animatedDuration;
  final Function()? onTap;
  const OnHover({super.key,  this.builder, this.child,  this.hoveredMatrix4, this.hoverScale,  this.animatedDuration, this.onTap});

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;





  @override
  Widget build(BuildContext context) {
    Matrix4 hoveredTransform = widget.hoveredMatrix4??Static.onHoverDefaultMatrix4??Matrix4.identity()..scale(widget.hoverScale??Static.onHoverDefaultScale??1.1);
    var transform = isHovered?hoveredTransform:Matrix4.identity();
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
            duration: widget.animatedDuration??Static.onHoverDefaultAnimatedDuration??100.milliseconds,
            transform: transform,
            child: widget.builder == null?widget.child:widget.builder!(isHovered),
        ),
      ),
    );
  }

  onEntered(bool isHovered) => setState(()=> this.isHovered = isHovered);


}