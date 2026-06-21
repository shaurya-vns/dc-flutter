import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final double? w;
  final double? h;
  final double rounded;
  final double stroke;
  final double padding;
  final Color color;
  final Color border;
  final Alignment alignment;

  RoundedContainer({
    this.child,
    this.w = null,
    this.h = null,
    this.rounded = 12,
    this.stroke = 1,
    this.padding = 0,
    this.alignment = Alignment.center,
    this.color = AppColor.color_E6E8EA,
    this.border = AppColor.color_E6E8EA,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: w ?? null,
      height: h ?? null,
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
