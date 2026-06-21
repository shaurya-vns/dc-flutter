import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/widgetUtils.dart';

class ScrollBaseWidget extends StatefulWidget {
  final Widget? child;
  final Function? callback;

  ScrollBaseWidget({required this.child, this.callback});

  @override
  State<ScrollBaseWidget> createState() => _ScrollBaseWidgetState();
}

class _ScrollBaseWidgetState extends State<ScrollBaseWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.callback == null
        ? _scroll()
        : RefreshIndicator(onRefresh: () async {}, child: _scroll());
  }

  Widget _scroll() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: widget.child,
    );
  }
}
