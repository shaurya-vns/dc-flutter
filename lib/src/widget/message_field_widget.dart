import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/widgetUtils.dart';
import 'test_semi.dart';

class MessageFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final StreamController<String> stream;
  final String field;
  final Function(String value) onTypeChange;
  final int? maxLength;
  final int? maxLines;
  final bool? optional;
  final FocusNode? preNode;

  MessageFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.stream,
    required this.field,
    this.maxLength = 500,
    this.maxLines = 6,
    this.optional = false,
    required this.preNode,
    required this.onTypeChange,
  });

  @override
  _MessageFieldWidgetState createState() => _MessageFieldWidgetState();
}

class _MessageFieldWidgetState extends State<MessageFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetFirstNameUI(widget.field);
  }

  Widget _widgetFirstNameUI(String name) {
    return StreamBuilder<String>(
      stream: widget.stream.stream,
      builder: (context, snapshot) {
        String error = '';
        if (snapshot.hasData) {
          error = snapshot.data ?? '';
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextSemi(
              str: name,
              size: 16,
              color: error == '' ? AppColor.black : AppColor.red,
            ),
            const SizedBox(height: 5),
            _widgetFirstNameField(error, name),
            const SizedBox(height: 2),
            WidgetUtils.widgetGetErrorUI(widget.stream),
          ],
        );
      },
    );
  }

  Widget _widgetFirstNameField(String error, String name) {
    return TextFormField(
      focusNode: widget.preNode,
      onChanged: (value) {
        widget.onTypeChange(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textCapitalization: TextCapitalization.sentences,
      cursorColor: AppColor.black,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.multiline,
      maxLines: widget.maxLines ?? 6,
      maxLength: widget.maxLength ?? 1000,
      controller: widget.controller,
      textAlign: TextAlign.start,

      style: TextStyle(
        color: AppColor.color_041526,
        fontFamily: Fonts.REGULAR,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
        labelStyle: const TextStyle(
          color: AppColor.black,
          fontFamily: Fonts.BOLD,
          fontSize: 22,
        ),
        filled: true,
        isCollapsed: true,
        hintStyle: const TextStyle(
          color: AppColor.color_B0B0B0,
          fontFamily: Fonts.REGULAR,
          fontSize: 15,
        ),

        fillColor: AppColor.white,
      ),
    );
  }
}
