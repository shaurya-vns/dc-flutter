import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class ScaffoldWidget extends StatelessWidget {
  final Widget child;
  final Widget? bottom;
  final Widget back;
  final Function? onSwipe;
  final bool isBottom;

  const ScaffoldWidget({
    super.key,
    required this.child,
    this.bottom,
    this.onSwipe,
    this.isBottom = true,
    required this.back,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColor.white,
      ),
      bottomNavigationBar: bottom,
      body: Stack(
        children: [Padding(padding: const EdgeInsets.only(top: 55), child: child), back],
      ),
    );
  }
}
