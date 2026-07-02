import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';

class ScaffoldWidget extends StatelessWidget {
  final Widget child;
  final Widget? bottom;
  final Function? onSwipe;
  final bool isBottom;
  final String? title;

  const ScaffoldWidget({
    super.key,
    required this.child,
    this.bottom,
    this.onSwipe,
    this.isBottom = true,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return onSwipe == null
        ? SafeArea(top: false, bottom: bottom == null ? false : true, child: _widgetUI())
        : RefreshIndicator(
          onRefresh: () async {
            if (onSwipe != null) {
              onSwipe!();
            }
          },
          child: SafeArea(
            top: false,
            bottom: bottom == null ? false : true,
            child: _widgetUI(),
          ),
        );
  }

  Widget _widgetUI() {
    return Scaffold(
      backgroundColor: AppColor.color_bg,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.color_bg,
        foregroundColor: Colors.black,
        title: Text(
          title ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      bottomNavigationBar: bottom,
      body: child,
    );
  }
}
