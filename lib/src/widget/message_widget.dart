import 'package:flutter/material.dart';
import 'CustomMarkdownText.dart';

class MessageWidget extends StatelessWidget {
  final String? msg;

  MessageWidget({this.msg});

  @override
  Widget build(BuildContext context) {
    return CustomMarkdownText(text: msg, selectable: true);
  }
}
