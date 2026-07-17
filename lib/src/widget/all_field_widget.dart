import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';
import '../utils/gap.dart';

class AllFieldWidget extends StatefulWidget {
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

  AllFieldWidget({
    this.textInputAction = TextInputAction.next,
    this.format = FORMAT.ALL,
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
  _AllFieldWidgetState createState() => _AllFieldWidgetState();
}

class _AllFieldWidgetState extends State<AllFieldWidget> {
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
        fontSize: 14,
      ),
      obscureText: widget.isPassword == true ? !_showPassword : false,
      decoration: InputDecoration(
        hintText: name,
        contentPadding: EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
        counterText: '',
        prefixIcon: Icon(widget.icon, size: 20),
        suffixIcon:
            widget.isPassword == true
                ? IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                )
                : SizedBox(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextInputType getKeyboardType() {
    if (widget.format == FORMAT.ALL || widget.format == FORMAT.CAP) {
      return TextInputType.text;
    } else if (widget.format == FORMAT.EMAIL) {
      return TextInputType.emailAddress;
    } else if (widget.format == FORMAT.DIGIT) {
      return TextInputType.number;
    } else if (widget.format == FORMAT.PHONE) {
      return TextInputType.number;
    } else if (widget.format == FORMAT.UPI) {
      return TextInputType.emailAddress;
    }
    return TextInputType.text;
  }

  TextCapitalization getTextCapitalization() {
    if (widget.format == FORMAT.ALL) {
      return TextCapitalization.words;
    } else if (widget.format == FORMAT.EMAIL) {
      return TextCapitalization.none;
    } else if (widget.format == FORMAT.DIGIT) {
      return TextCapitalization.sentences;
    } else if (widget.format == FORMAT.PHONE) {
      return TextCapitalization.sentences;
    } else if (widget.format == FORMAT.CAP) {
      return TextCapitalization.characters;
    } else if (widget.format == FORMAT.ALPHA_NUMERIC) {
      return TextCapitalization.characters;
    } else if (widget.format == FORMAT.FIRST_NAME) {
      return TextCapitalization.words;
    } else if (widget.format == FORMAT.GST) {
      return TextCapitalization.characters;
    } else if (widget.format == FORMAT.UPI) {
      return TextCapitalization.none;
    }
    return TextCapitalization.words;
  }

  List<TextInputFormatter>? getFormat() {
    if (widget.format == FORMAT.ALL) {
      return null;
    } else if (widget.format == FORMAT.EMAIL) {
      return null;
    } else if (widget.format == FORMAT.UPI) {
      return null;
    } else if (widget.format == FORMAT.DIGIT) {
      return [FilteringTextInputFormatter.digitsOnly];
    } else if (widget.format == FORMAT.PHONE) {
      return [FilteringTextInputFormatter.digitsOnly];
    } else if (widget.format == FORMAT.REG) {
    } else if (widget.format == FORMAT.ALPHA_NUMERIC) {
      final allowedRegex = RegExp(r"[a-zA-Z0-9]");
      return [FilteringTextInputFormatter.allow(allowedRegex)];
    } else if (widget.format == FORMAT.FIRST_NAME) {
      return [FilteringTextInputFormatter(RegExp(r'[a-z,A-Z ]'), allow: true)];
    } else if (widget.format == FORMAT.GST) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
        LengthLimitingTextInputFormatter(15),
      ];
    }
    return null;
  }
}

class FORMAT {
  static const int ALL = 1;
  static const int PHONE = 2;
  static const int EMAIL = 3;
  static const int DIGIT = 4;
  static const int CAP = 5;
  static const int REG = 6;
  static const int ALPHA_NUMERIC = 7;
  static const int PASSWORD = 8;
  static const int FIRST_NAME = 9;
  static const int GST = 10;
  static const int UPI = 11;
}
