import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class TextRegular extends StatelessWidget {
  final String? str;
  final Color? color;
  final double? size;
  final int? max;
  final int? align;
  final bool? line;
  final bool? cross;

  const TextRegular({
    required this.str,
    this.align = 0,
    this.max,
    this.line = false,
    this.cross = false,
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
        decoration:
            line == true
                ? TextDecoration.underline
                : cross == true
                ? TextDecoration.lineThrough
                : TextDecoration.none,
        color: color,
        decorationThickness: 4,
        decorationColor: AppColor.color_D25B17,
        fontFamily: Fonts.REGULAR,
        fontSize: size,
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
