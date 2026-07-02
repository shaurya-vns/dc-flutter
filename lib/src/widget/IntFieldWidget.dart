import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';

class IntFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String field;
  final FocusNode? preNode;
  final int? max;
  final Function(String value) onTypeChange;
  final TextCapitalization? textCapitalization;

  IntFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.field,
    required this.preNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.max = 100,
    required this.onTypeChange,
  });

  @override
  _IntFieldWidgetState createState() => _IntFieldWidgetState();
}

class _IntFieldWidgetState extends State<IntFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetFirstNameUI(widget.field, widget.preNode);
  }

  Widget _widgetFirstNameUI(String field, FocusNode? preNode) {
    return TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      focusNode: preNode,
      onChanged: (value) {
        widget.onTypeChange(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
      cursorColor: AppColor.black,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      maxLength: widget.max,
      controller: widget.controller,
      style: const TextStyle(color: AppColor.black, fontFamily: Fonts.BOLD, fontSize: 15),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(top: 15, bottom: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.color_737373, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.color_DADADA, width: 1),
        ),
        filled: true,
        labelText: null,
        hintStyle: const TextStyle(
          color: AppColor.color_B0B0B0,
          fontFamily: Fonts.BOLD,
          fontSize: 15,
        ),
        hintText: field,
        isCollapsed: true,
        fillColor: AppColor.white,
      ),
    );
  }
}
