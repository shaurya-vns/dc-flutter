import 'package:flutter/material.dart';
import '../constants/color_constants.dart';
import '../utils/app_constant.dart';

class CustomLine extends StatelessWidget {
  final double h;

  CustomLine({this.h = 1});

  @override
  Widget build(BuildContext context) {
    return Container(width: SCREEN_WIDTH, height: h, color: AppColor.color_DADADA);
  }
}
