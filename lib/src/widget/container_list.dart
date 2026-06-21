import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class ContainerList extends StatelessWidget {
  final Widget child;
  final double padding;
  final double gap;

  const ContainerList({required this.child, this.padding = 15, this.gap = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
