import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/log.dart';

class BorderlineButtonWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color color;
  final double? height;
  final double? width;
  final double? rounded;
  final double? radiusWidth;

  const BorderlineButtonWidget({
    super.key,
    this.radiusWidth = 1,
    this.height = 50,
    this.width,
    this.rounded = 30,
    this.borderColor = AppColor.black,
    this.color = AppColor.white,
    required this.child,
    required this.onPressed,
  });

  @override
  State<BorderlineButtonWidget> createState() => _BorderlineButtonWidgetState();
}

class _BorderlineButtonWidgetState extends State<BorderlineButtonWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: widget.width ?? w,
      height: widget.height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 10,
          backgroundColor: widget.color,
          side: BorderSide(width: widget.radiusWidth ?? 1, color: widget.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.rounded ?? 10)),
          ),
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
