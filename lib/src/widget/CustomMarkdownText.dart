import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';
import '../utils/app_utils.dart';

class CustomMarkdownText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final double fontSize;
  final String? font;
  final bool selectable;

  const CustomMarkdownText({
    super.key,
    required this.text,
    this.style,
    this.selectable = false,
    this.font = Fonts.REGULAR,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(selectionColor: AppColor.neonGreen),
        ),
        child: MarkdownBody(
          selectable: selectable,
          data: fixApiMarkdown(text ?? ''),
          softLineBreak: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontFamily: font,
              color: AppColor.black,
              fontSize: fontSize,
              height: 1.5,
            ),
          ),

          onTapLink: (text, href, title) {
            if (href != null && href.contains('mailto')) {
              AppUtils.navigateEmail(toEmail: href);
            } else {
              AppUtils.navigateWebLink(href);
            }
          },
        ),
      ),
    );
  }

  String fixApiMarkdown(String raw) {
    final lines = raw.split('\n');
    final cleanedLines = <String>[];

    final headingPattern = RegExp(r'^#{1,6}\s*\d+\.\s+\*\*(.*?)\*\*:?$');
    final bulletPattern = RegExp(r'^\s*-\s+');

    for (var line in lines) {
      if (headingPattern.hasMatch(line)) {
        // Remove colon and unnecessary spaces in headers
        final match = headingPattern.firstMatch(line);
        final title = match?.group(1)?.trim() ?? '';
        cleanedLines.add('### **$title**');
      } else if (bulletPattern.hasMatch(line)) {
        // Trim leading spaces before dashes
        cleanedLines.add(line.trimLeft());
      } else {
        cleanedLines.add(line.trimRight());
      }
    }

    return cleanedLines.join('\n');
  }
}
