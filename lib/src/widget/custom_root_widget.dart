import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class CustomRootWidget extends StatelessWidget {
  final Widget? bottomWidget;
  final Widget bodyWidget;
  final bool top;
  final bool bottom;
  final Color color;
  final Color status;

  const CustomRootWidget({
    this.bottomWidget,
    this.top = false,
    this.bottom = false,
    this.color = AppColor.white,
    this.status = AppColor.white,
    required this.bodyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: status),
        bottomNavigationBar: bottomWidget == null ? SizedBox() : bottomWidget,
        backgroundColor: color,
        body: bodyWidget,
      ),
    );
  }
}
