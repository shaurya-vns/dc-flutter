import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class ClickWidget extends StatefulWidget {
  final Widget child;
  final Function? onClick;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;

  const ClickWidget({
    required this.child,
    required this.onClick,
    this.paddingTop = 6.0,
    this.paddingLeft = 6.0,
    this.paddingRight = 6,
  });

  @override
  _ClickWidgetState createState() => _ClickWidgetState();
}

class _ClickWidgetState extends State<ClickWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        top: widget.paddingTop,
        right: widget.paddingRight,
        bottom: widget.paddingTop,
      ),
      constraints: const BoxConstraints(),
      // override default min size of 48px
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
      ),
      onPressed:
          widget.onClick == null
              ? null
              : () {
                widget.onClick!();
              },
      icon: widget.child,
    );
  }
}
