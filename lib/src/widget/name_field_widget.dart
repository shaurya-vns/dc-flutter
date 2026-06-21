import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../utils/widgetUtils.dart';
import 'test_semi.dart';

class NameFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final StreamController<String> stream;
  final String field;
  final FocusNode? preNode;
  final FocusNode? nextNode;
  final bool? readOnly;
  final Function(String value) onTypeChange;

  NameFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.stream,
    required this.field,
    required this.preNode,
    required this.nextNode,
    this.readOnly = false,
    required this.onTypeChange,
  });

  @override
  _NameFieldWidgetState createState() => _NameFieldWidgetState();
}

class _NameFieldWidgetState extends State<NameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetFirstNameUI(
      widget.field,
      widget.preNode,
      widget.nextNode,
      widget.readOnly,
    );
  }

  Widget _widgetFirstNameUI(
    String field,
    FocusNode? preNode,
    FocusNode? nextNode,
    bool? readOnly,
  ) {
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
              str: field,
              size: 16,
              color: error == '' ? AppColor.black : AppColor.red,
            ),
            _widgetField(error, field, preNode, nextNode, readOnly),
            const SizedBox(height: 2),
            WidgetUtils.widgetGetErrorUI(widget.stream),
          ],
        );
      },
    );
  }

  Widget _widgetField(
    String error,
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
      textCapitalization: TextCapitalization.words,
      inputFormatters: [FilteringTextInputFormatter(RegExp(r'[a-z,A-Z ]'), allow: true)],
      cursorColor: AppColor.black,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      maxLength: 50,
      readOnly: readOnly ?? false,
      controller: widget.controller,
      style: const TextStyle(
        color: AppColor.black,
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
