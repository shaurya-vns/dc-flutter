import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';

class ClickImage extends StatefulWidget {
  final String icon;
  final Function? onPressed;
  final double size;
  final double padding;

  const ClickImage({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 17.0,
    this.padding = 6.0,
  });

  @override
  _ClickImageState createState() => _ClickImageState();
}

class _ClickImageState extends State<ClickImage> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(widget.padding),
      constraints: const BoxConstraints(),
      onPressed: () {
        if (widget.onPressed != null) widget.onPressed!();
      },
      icon: Image.asset(
        widget.icon,
        color: AppColor.black,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
