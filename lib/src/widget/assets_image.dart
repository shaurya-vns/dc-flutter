import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../utils/app_constant.dart';
import 'IconImage.dart';
import 'rounded_container.dart';

class AssetsImage extends StatelessWidget {
  final String icon;
  final double? width;
  final double height;
  final double round;
  final BoxFit fit;
  final Color color;
  final double padding;
  final Color? iconColor;
  final Color? iconBorderColor;
  final double? iconBorderWidth;

  AssetsImage({
    required this.icon,
    this.width = 35,
    this.height = 35,
    this.round = 5,
    this.padding = 0,
    this.color = AppColor.trans,
    this.iconColor,
    this.iconBorderColor = AppColor.trans,
    this.iconBorderWidth = 2,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      border: AppColor.trans,
      w: width,
      h: height,
      rounded: round,
      padding: padding,
      color: color,
      child:
          iconColor == null
              ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(round)),
                child: Image.asset(icon, fit: fit, width: width, height: height),
              )
              : Image.asset(icon, color: iconColor, fit: fit),
    );
  }
}
