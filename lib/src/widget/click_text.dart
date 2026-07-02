import 'package:flutter/material.dart';

class ClickText extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;

  const ClickText({
    super.key,
    required this.child,
    required this.onPressed,
    this.paddingTop = 4.0,
    this.paddingLeft = 4.0,
    this.paddingRight = 4,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingTop,
          left: paddingLeft,
          right: paddingRight,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      onPressed: onPressed,
      child: child,
    );
  }
}
