import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';

class AllFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;

  final String field;
  final FocusNode? preNode;
  final FocusNode? nextNode;
  final bool? readOnly;
  final int? max;
  final Function(String value) onTypeChange;
  final TextCapitalization? textCapitalization;

  AllFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,

    required this.field,
    required this.preNode,
    required this.nextNode,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.max = 100,
    required this.onTypeChange,
  });

  @override
  _AllFieldWidgetState createState() => _AllFieldWidgetState();
}

class _AllFieldWidgetState extends State<AllFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetField(widget.field, widget.preNode, widget.preNode, widget.readOnly);
  }

  Widget _widgetField(
    String name,
    FocusNode? preNode,
    FocusNode? nextNode,
    bool? readOnly,
  ) {
    return TextField(
      focusNode: preNode,
      onChanged: (value) {
        widget.onTypeChange(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onEditingComplete: () {
        if (nextNode == null) {
          FocusScope.of(context).unfocus();
        } else {
          FocusScope.of(context).requestFocus(nextNode);
        }
      },
      textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
      cursorColor: AppColor.black,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: nextNode == null ? TextInputAction.done : TextInputAction.next,
      maxLines: 1,
      maxLength: widget.max,
      readOnly: readOnly ?? false,
      controller: widget.controller,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColor.black,
        fontFamily: Fonts.SEMI_BOLD,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.color_DADADA, width: 1),
        ),
        filled: true,
        labelText: null,
        hintStyle: const TextStyle(
          color: AppColor.color_B0B0B0,
          fontFamily: Fonts.REGULAR,
          fontSize: 15,
        ),
        hintText: name,
        isCollapsed: true,
        fillColor: readOnly == true ? AppColor.white : AppColor.white,
      ),
    );
  }
}
