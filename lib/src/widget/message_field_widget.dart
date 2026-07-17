import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class MessageFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String hint;
  final Function(String value) onTypeChange;
  final int? maxLength;
  final int? maxLines;
  final FocusNode? preNode;

  MessageFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,
    this.hint = '',
    this.maxLength = 500,
    this.maxLines = 6,
    this.preNode,
    required this.onTypeChange,
  });

  @override
  _MessageFieldWidgetState createState() => _MessageFieldWidgetState();
}

class _MessageFieldWidgetState extends State<MessageFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetFirstNameUI(widget.hint);
  }

  Widget _widgetFirstNameUI(String hint) {
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
        fontSize: 14,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
        labelStyle: const TextStyle(
          color: AppColor.black,
          fontFamily: Fonts.BOLD,
          fontSize: 22,
        ),
        filled: true,
        hintText: hint,
        isCollapsed: true,
        hintStyle: const TextStyle(
          color: AppColor.black,
          fontFamily: Fonts.REGULAR,
          fontSize: 14,
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
