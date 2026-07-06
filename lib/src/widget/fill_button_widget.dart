import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/ext.dart';

class FillButtonWidget extends StatefulWidget {
  final Color bgColor;
  final String title;
  final Color color;
  final double? fontSize;
  final double? height;
  final double? radius;
  final double? width;
  final String? fontFamily;
  final VoidCallback? onPressed;

  FillButtonWidget({
    super.key,
    this.height = 45,
    this.width,
    this.color = AppColor.white,
    this.radius = 30,
    this.fontSize = 16,
    this.bgColor = AppColor.color_1E6F46,
    this.fontFamily = Fonts.SEMI_BOLD,
    required this.title,
    required this.onPressed,
  });

  @override
  _FillButtonWidgetState createState() => _FillButtonWidgetState();
}

class _FillButtonWidgetState extends State<FillButtonWidget> {
  double sizeF = 17;

  @override
  Widget build(BuildContext context) {
    if (widget.fontSize == null) {
      sizeF = 15;
    } else {
      sizeF = widget.fontSize!;
    }

    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: widget.width ?? w,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 10)),
          ),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: sizeF,
            fontFamily: widget.fontFamily,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
