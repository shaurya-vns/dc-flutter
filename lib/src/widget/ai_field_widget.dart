import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class AIFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode messageNode;
  final bool autoFocus;
  final Function() onSubmitted;
  final Function(String? str) onChanged;
  final isAIAssistant;

  AIFieldWidget({
    super.key,
    required this.controller,
    required this.messageNode,
    this.autoFocus = false,
    this.isAIAssistant = false,
    required this.onSubmitted,
    required this.onChanged,
  });

  @override
  _AIFieldWidgetState createState() => _AIFieldWidgetState();
}

class _AIFieldWidgetState extends State<AIFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autoFocus,
      focusNode: widget.messageNode,
      onChanged: (value) {
        widget.onChanged(value.trim());
      },
      onTapOutside: (PointerDownEvent event) {
        if (widget.isAIAssistant) return;
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onSubmitted: (value) {
        widget.onSubmitted();
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      cursorColor: AppColor.black,
      cursorWidth: 2,
      keyboardAppearance: Brightness.dark,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      maxLength: 500,
      controller: widget.controller,
      style: const TextStyle(
        color: AppColor.black,
        fontFamily: Fonts.REGULAR,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 10, right: 15, top: 0, bottom: 0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white, width: 1),
        ),
        filled: true,
        labelText: null,
        hintStyle: const TextStyle(
          color: AppColor.color_424242,
          fontFamily: Fonts.REGULAR,
          fontSize: 14,
        ),
        hintText: 'How can I help you?',
        isCollapsed: true,
        fillColor: AppColor.white,
      ),
    );
  }
}
