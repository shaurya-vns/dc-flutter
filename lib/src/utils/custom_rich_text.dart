import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class CustomRichText extends StatelessWidget {
  final String? normalText;
  final List<RichTextPart>? parts;
  final double defaultSize;
  final Color defaultColor;
  final String font;

  const CustomRichText({
    super.key,
    this.normalText,
    this.parts,
    this.defaultSize = 14,
    this.font = Fonts.SEMI_BOLD,
    this.defaultColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: normalText,
        style: TextStyle(fontFamily: font, fontSize: defaultSize, color: defaultColor),
        children:
            parts?.map((p) {
              return TextSpan(
                text: p.text,
                style: TextStyle(
                  color: p.color ?? AppColor.black,
                  fontSize: p.fontSize ?? defaultSize,
                  fontFamily: p.font ?? Fonts.REGULAR,
                ),
              );
            }).toList(),
      ),
    );
  }
}

class RichTextPart {
  final String text;
  final Color? color;
  final double? fontSize;
  final String? font;

  RichTextPart({required this.text, this.color, this.fontSize, this.font});
}
