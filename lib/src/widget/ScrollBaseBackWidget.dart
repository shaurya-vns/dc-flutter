import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/widgetUtils.dart';

class ScrollBaseBackWidget extends StatefulWidget {
  final Widget? child;
  final Function? callback;
  final String title;

  ScrollBaseBackWidget({required this.child, required this.title, this.callback});

  @override
  State<ScrollBaseBackWidget> createState() => _ScrollBaseBackWidgetState();
}

class _ScrollBaseBackWidgetState extends State<ScrollBaseBackWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.callback == null
        ? _scroll()
        : RefreshIndicator(onRefresh: () async {}, child: _scroll());
  }

  Widget _scroll() {
    return Stack(
      children: [
        WidgetUtils.getBackUI(context, title: widget.title),
        Padding(
          padding: EdgeInsets.only(top: widget.title == '' ? 0 : 50),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
