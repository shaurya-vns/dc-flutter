import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class SearchWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final FocusNode? preNode;
  final String? hint;
  final bool? autoSearch;
  final Function(String value) onTypeChange;
  final TextCapitalization? textCapitalization;

  SearchWidget({
    required this.preNode,
    this.textInputAction = TextInputAction.done,
    required this.controller,
    this.hint,
    this.autoSearch,
    this.textCapitalization = TextCapitalization.words,
    required this.onTypeChange,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return TextFormField(
      autofocus: widget.autoSearch ?? false,
      focusNode: widget.preNode,
      onChanged: (value) {
        widget.onTypeChange(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      textCapitalization: widget.textCapitalization ?? TextCapitalization.words,
      cursorColor: AppColor.color_D25B17,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      maxLines: 1,
      maxLength: 20,
      controller: widget.controller,
      style: const TextStyle(
        color: AppColor.color_D25B17,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.black, width: 1),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: AppColor.black,
          fontFamily: Fonts.LIGHT,
          fontSize: 15,
        ),
        hintText: widget.hint,
        fillColor: AppColor.white,
        suffixIcon: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            DrawableConstant.ic_search,
            color: AppColor.white,
            width: 10,
            height: 10,
          ),
        ),
      ),
    );
  }
}
