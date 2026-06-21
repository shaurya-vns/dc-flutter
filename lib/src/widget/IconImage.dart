import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../utils/app_constant.dart';

class IconImage extends StatelessWidget {
  final String icon;
  final double? width;
  final double? height;
  final Color? color;

  IconImage({required this.icon, this.width = 25, this.height = 25, this.color});

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return Image.asset(icon, width: width, height: height);
    } else {
      return Image.asset(icon, width: width, height: height, color: color);
    }
  }
}
