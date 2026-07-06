import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color_constants.dart';
import '../../utils/gap.dart';

class CoachFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final StreamController<String>? stream;

  final String field;
  final String hint;
  final FocusNode? preNode;
  final FocusNode? nextNode;
  final bool? readOnly;
  final int format;
  final int? max;
  final bool? isPassword;
  final Color? fillColor;
  final textColor;
  final Function(String value) onTypeChange;
  final IconData icon;

  CoachFieldWidget({
    this.textInputAction = TextInputAction.next,
    this.format = FORMAT1.ALL,
    required this.controller,
    this.stream = null,
    required this.field,
    required this.preNode,
    required this.nextNode,
    this.icon = Icons.phone,
    this.readOnly = false,
    this.fillColor = AppColor.trans,
    this.isPassword = false,
    this.hint = '',
    this.textColor = AppColor.black,
    this.max = 100,
    required this.onTypeChange,
  });

  @override
  _CoachFieldWidgetState createState() => _CoachFieldWidgetState();
}

class _CoachFieldWidgetState extends State<CoachFieldWidget> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(h: 6),
        _widgetField(widget.field, widget.preNode, widget.nextNode, widget.readOnly),
      ],
    );
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
      inputFormatters: getFormat(),
      textCapitalization: getTextCapitalization(),
      cursorColor: widget.textColor,
      keyboardAppearance: Brightness.light,
      keyboardType: getKeyboardType(),
      textInputAction: nextNode == null ? TextInputAction.done : TextInputAction.next,
      maxLines: 1,
      maxLength: widget.max,
      readOnly: readOnly ?? false,
      controller: widget.controller,
      style: TextStyle(
        color: widget.textColor,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),

      decoration: InputDecoration(
        hintText: name,
        contentPadding: EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 14),
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextInputType getKeyboardType() {
    if (widget.format == FORMAT1.ALL) {
      return TextInputType.text;
    }
    return TextInputType.numberWithOptions(decimal: true, signed: true);
  }

  TextCapitalization getTextCapitalization() {
    if (widget.format == FORMAT1.ALL) {
      return TextCapitalization.words;
    }
    return TextCapitalization.words;
  }

  List<TextInputFormatter>? getFormat() {
    switch (widget.format) {
      case FORMAT1.LAT:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
          LengthLimitingTextInputFormatter(15),
        ];
    }
    return null;
  }
}

class FORMAT1 {
  static const int ALL = 1;
  static const int LAT = 2;
}
