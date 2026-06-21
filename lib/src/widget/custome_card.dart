import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../utils/app_constant.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double rounded;
  final double elevation;
  final Color color;

  CustomCard({
    required this.child,
    this.rounded = 10,
    this.elevation = 0,
    this.color = AppColor.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rounded)),
      child: child,
    );
  }
}
