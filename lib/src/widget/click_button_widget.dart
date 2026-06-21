import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/app_constant.dart';

class ClickButtonWidget extends StatefulWidget {
  final Widget child;

  final Color color;

  final double? height;
  final double? rounded;

  final double elevation;
  final double? width;

  final VoidCallback onPressed;

  ClickButtonWidget({
    super.key,
    this.height,
    this.elevation = 0,
    this.rounded = 15,
    required this.child,
    this.width,
    this.color = AppColor.white,
    required this.onPressed,
  });

  @override
  _ClickButtonWidgetState createState() => _ClickButtonWidgetState();
}

class _ClickButtonWidgetState extends State<ClickButtonWidget> {
  double w = SCREEN_WIDTH;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: widget.width ?? null,
      height: widget.height ?? null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          shadowColor: AppColor.white,
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.rounded ?? 20)),
          ),
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
