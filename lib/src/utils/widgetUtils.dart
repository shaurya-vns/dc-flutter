import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../widget/click_button_widget.dart';
import '../widget/click_widget.dart';
import '../widget/test_bold.dart';
import '../widget/test_semi.dart';
import 'app_constant.dart';

class WidgetUtils {
  static Widget getFieldValue(String str, {bool isStart = false}) {
    return Row(
      children: [
        Text(
          str,
          style: const TextStyle(
            fontSize: 17,
            color: AppColor.black,
            fontFamily: Fonts.SEMI_BOLD,
          ),
        ),
        Text(
          isStart ? '*' : '',
          style: const TextStyle(
            fontSize: 17,
            color: AppColor.color_D25B17,
            fontFamily: Fonts.REGULAR,
          ),
        ),
      ],
    );
  }

  static Widget getError(String str) {
    return Text(
      str,
      style: const TextStyle(
        fontSize: 14,
        color: AppColor.color_D25B17,
        fontFamily: Fonts.REGULAR,
      ),
    );
  }

  static Widget getTitle(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 22, color: AppColor.black, fontFamily: Fonts.BOLD),
    );
  }

  static Widget getTitle1(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 17, color: AppColor.black, fontFamily: Fonts.BOLD),
    );
  }

  static Widget getTitle2(String str) {
    return Text(
      str,
      style: const TextStyle(
        fontSize: 15,
        color: AppColor.black,
        fontFamily: Fonts.REGULAR,
      ),
    );
  }

  static Widget getTitle3(String str) {
    return Text(
      str,
      style: const TextStyle(
        fontSize: 14,
        color: AppColor.black,
        fontFamily: Fonts.LIGHT,
      ),
    );
  }

  static Widget widgetGetErrorUI(StreamController<String> stream) {
    return StreamBuilder<String>(
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
          String error = snapshot.data ?? '';
          return Container(child: WidgetUtils.getError(error));
        } else {
          return const Text(
            '',
            style: TextStyle(
              fontSize: 11,
              color: AppColor.red,
              fontFamily: Fonts.REGULAR,
            ),
          );
        }
      },
    );
  }

  static Widget getBackUI(
    BuildContext context, {
    Color color = AppColor.white,
    String title = '',
  }) {
    return Container(
      width: SCREEN_WIDTH,
      height: 50,
      color: AppColor.color_E65C0E,
      child: Row(
        children: [
          ClickWidget(
            onClick: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(10),
              child: Image.asset(color: color, DrawableConstant.ic_back),
            ),
          ),

          Expanded(child: TextSemi(str: title, color: AppColor.white, size: 17)),
        ],
      ),
    );
  }

  static Widget getMoreBack(
    BuildContext context, {
    required String str,
    Function? callback,
  }) {
    return ClickButtonWidget(
      rounded: 40,
      width: SCREEN_WIDTH / 2,
      height: 45,
      color: AppColor.color_E65C0E,
      onPressed: () {
        if (callback != null) {
          callback();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 5),
          TextBold(str: str, color: AppColor.white, size: 14),
          Spacer(flex: 1),
          Image.asset(
            height: 15,
            width: 15,
            color: AppColor.white,
            DrawableConstant.ic_right_back,
          ),
        ],
      ),
    );
  }

  static Widget getTitleUI(String title) {
    return Container(
      width: SCREEN_WIDTH,
      height: 50,
      alignment: Alignment.centerLeft,
      color: AppColor.color_E65C0E,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: TextBold(str: title, color: AppColor.white, size: 17),
      ),
    );
  }

  static Widget widgetEmailField(
    TextEditingController controller,
    String error,
    Function(String value) onChangedData,
  ) {
    return TextField(
      onChanged: (value) {
        onChangedData(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: controller,
      maxLines: 1,
      maxLength: 50,
      style: const TextStyle(
        color: AppColor.black,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error == '' ? AppColor.colorBlue : AppColor.red,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.color_D6D6D6, width: 1),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: AppColor.color_BBBBBB,
          fontFamily: Fonts.LIGHT,
          fontSize: 15,
        ),
        hintText: 'Email ID',
        fillColor: AppColor.white,
      ),
    );
  }
}
