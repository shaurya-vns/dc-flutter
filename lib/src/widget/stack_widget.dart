import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../utils/app_constant.dart';
import '../utils/widgetUtils.dart';
import 'test_semi.dart';

class StackWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const StackWidget({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 62),
          child: SingleChildScrollView(scrollDirection: Axis.vertical, child: child),
        ),
        _widgetBack(context),
      ],
    );
  }

  Widget _widgetBack(context) {
    return Container(
      height: 55,
      width: SCREEN_WIDTH,
      color: AppColor.color_002B56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: WidgetUtils.getBackUI(context, color: AppColor.white),
          ),
          TextSemi(str: title, color: AppColor.white, size: 16),
        ],
      ),
    );
  }
}
