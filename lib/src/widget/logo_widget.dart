import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class LogoWidget extends StatefulWidget {
  final bool isShow;

  LogoWidget({this.isShow = false});

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isShow == true ? _widgetRow(75, 60, 45) : _widgetRow(75, 60, 45);
  }

  Widget _widgetRow(double w, double h, double h1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(fit: BoxFit.fill, DrawableConstant.ic_splash, width: w, height: h),
      ],
    );
  }
}
