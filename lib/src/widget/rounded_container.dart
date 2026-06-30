import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final double rounded;
  final double stroke;
  final double padding;
  final Color color;
  final Color border;
  final Alignment alignment;
  final double paddingT;
  final double paddingL;
  final double paddingB;
  final double paddingR;

  RoundedContainer({
    this.child,
    this.width = null,
    this.height = null,
    this.rounded = 12,
    this.stroke = 1,
    this.padding = 0,
    this.paddingT = 0,
    this.paddingL = 0,
    this.paddingB = 0,
    this.paddingR = 0,
    this.alignment = Alignment.center,
    this.color = AppColor.color_E6E8EA,
    this.border = AppColor.color_E6E8EA,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width ?? null,
      height: height ?? null,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: border, width: stroke),
        borderRadius: BorderRadius.all(Radius.circular(rounded)),
      ),
      child: child ?? SizedBox(),
    );
  }
}
