import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class TextMedium extends StatelessWidget {
  final String? str;
  final Color color;
  final double? size;

  final int? align;

  TextMedium({
    required this.str,
    this.align = 0,
    this.color = AppColor.black,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      str ?? '',
      textAlign: getValue(),
      style: TextStyle(color: color, fontFamily: Fonts.MEDIUM, fontSize: size),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
  }

  TextAlign getValue() {
    if (align == 0) {
      return TextAlign.left;
    } else if (align == 1) {
      return TextAlign.right;
    }
    if (align == 2) {
      return TextAlign.center;
    }
    return TextAlign.left;
  }
}
