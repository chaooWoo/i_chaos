import 'package:flutter/material.dart';

import 'base_skeleton/base_skeleton_widget.dart';

class SkeletonRect extends BaseSkeletonWidget {
  final double? width;
  final double? height;
  final double? radius;
  final Color? color;

  SkeletonRect({Key? key, this.width, this.height, this.radius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color ?? skeletonColor, borderRadius: BorderRadius.circular(radius!)),
    );
  }
}
