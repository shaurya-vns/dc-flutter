import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import 'click_widget.dart';

class IconWidget extends StatefulWidget {
  final String icon;
  final double width;
  final double height;
  final Function onClick;
  final Color color;

  const IconWidget({
    required this.icon,
    this.width = 20,
    this.height = 20,
    this.color = AppColor.black,
    required this.onClick,
  });

  @override
  _IconWidgetState createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClickWidget(
      child: Image.asset(
        color: widget.color,
        widget.icon,
        width: widget.width,
        height: widget.height,
      ),
      onClick: widget.onClick,
    );
  }
}
