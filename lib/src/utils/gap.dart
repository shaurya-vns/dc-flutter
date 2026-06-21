import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/widgetUtils.dart';

class Gap extends StatelessWidget {
  final double? h;
  final double? w;

  Gap({this.h, this.w});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h, width: w);
  }
}
