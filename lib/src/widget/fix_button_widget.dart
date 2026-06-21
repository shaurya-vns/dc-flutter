import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class FixButtonWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color color;
  final double? height;
  final double? width;
  final double? radius;
  final double? radiusWidth;
  final double? elevation;

  const FixButtonWidget({
    super.key,
    this.radiusWidth = 1,
    this.height,
    this.width,
    this.elevation = 0,
    this.radius = 10,
    this.borderColor = AppColor.black,
    this.color = AppColor.white,
    required this.child,
    required this.onPressed,
  });

  @override
  State<FixButtonWidget> createState() => _FixButtonWidgetState();
}

class _FixButtonWidgetState extends State<FixButtonWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: widget.elevation,
          backgroundColor: widget.color,
          side: BorderSide(width: widget.radiusWidth ?? 1, color: widget.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 10)),
          ),
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
