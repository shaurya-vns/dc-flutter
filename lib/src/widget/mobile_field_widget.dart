import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../countrypicker/country_picker_utils.dart';
import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../utils/log.dart';
import '../utils/widgetUtils.dart';

class MobileFieldWidget extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final StreamController<String> stream;
  final String field;
  final FocusNode? preNode;
  final FocusNode? nextNode;
  final bool? readOnly;
  final Function(String value) onTypeChange;
  final Function(String code, String flag) onCountryChange;
  final String countryCode;
  final String countryFlag;

  MobileFieldWidget({
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.stream,
    this.countryCode = '+1',
    this.countryFlag = 'assets/flags/flag_us.png',
    required this.field,
    required this.preNode,
    required this.nextNode,
    this.readOnly = false,
    required this.onTypeChange,
    required this.onCountryChange,
  });

  @override
  _MobileFieldWidgetState createState() => _MobileFieldWidgetState();
}

class _MobileFieldWidgetState extends State<MobileFieldWidget> {
  String code = '+1';
  String flag = 'assets/flags/flag_us.png';

  @override
  void initState() {
    code = widget.countryCode;
    flag = widget.countryFlag;

    widget.onCountryChange(code, flag);
    super.initState();
  }

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
            const SizedBox(height: 5),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.color_DADADA, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          SizedBox(width: 15),
          InkWell(
            onTap: () {
              CountryPickerUtils().showCountryPicker(
                context,
                onItemClick: (country) {
                  code = country?.dialCode ?? '';
                  flag = country?.flag ?? '';
                  widget.onCountryChange(country?.dialCode ?? '', country?.flag ?? '');
                  setState(() {});
                },
              );
            },
            child: SizedBox(
              child: Row(
                children: [
                  Image.asset(flag, width: 20, height: 20),
                  const SizedBox(width: 7),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: Fonts.MEDIUM,
                      color: AppColor.color_002B56,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Image.asset(
                    color: AppColor.color_002B56,
                    DrawableConstant.ic_down,
                    width: 13,
                    height: 8,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: preNode,
              onChanged: (value) {
                widget.onTypeChange(value);
              },
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true),
              ],
              onEditingComplete: () {
                if (nextNode == null) {
                  FocusScope.of(context).unfocus();
                } else {
                  FocusScope.of(context).requestFocus(nextNode);
                }
              },
              controller: widget.controller,
              keyboardAppearance: Brightness.light,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              maxLength: 20,
              style: const TextStyle(
                color: AppColor.black,
                fontFamily: Fonts.REGULAR,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: '' == '' ? AppColor.trans : AppColor.trans,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.trans, width: 1),
                ),
                filled: true,
                hintStyle: const TextStyle(
                  color: AppColor.color_B0B0B0,
                  fontFamily: Fonts.REGULAR,
                  fontSize: 15,
                ),
                hintText: widget.field,
                fillColor: AppColor.white,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _widgetField1(
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
      cursorColor: AppColor.black,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.emailAddress,
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
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error == '' ? AppColor.color_737373 : AppColor.red,
            width: 1,
          ),
        ),
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
