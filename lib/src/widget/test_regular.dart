import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class TextRegular extends StatelessWidget {
  final String? str;
  final Color? color;
  final double? size;
  final int? max;
  final int? align;

  TextRegular({
    required this.str,
    this.align = 0,
    this.max = null,
    this.color = AppColor.black,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      str ?? '',
      maxLines: max,
      textAlign: getValue(),
      style: TextStyle(
        letterSpacing: 1,
        wordSpacing: 2,
        color: color,

        fontFamily: Fonts.REGULAR,
        fontSize: size,
      ),
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
