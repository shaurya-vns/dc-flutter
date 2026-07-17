import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../constants/fonts.dart';
import '../widget/click_button_widget.dart';
import '../widget/click_widget.dart';
import '../widget/test_bold.dart';
import '../widget/test_regular.dart';
import '../widget/test_semi.dart';
import 'app_constant.dart';
import 'gap.dart';

class WidgetUtils {
  static Widget getFieldValue(String str, {bool isStart = false}) {
    return Row(
      children: [
        Text(
          str,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.black,
            fontFamily: Fonts.SEMI_BOLD,
          ),
        ),
        Text(
          isStart ? '*' : '',
          style: const TextStyle(
            fontSize: 14,
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

  static Widget noOrderWidget({
    String title = "No Active Subscription",
    String message =
        "It looks like you haven't subscribed yet. Explore our meal plans and get started today!",
    VoidCallback? onRefresh,
  }) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(h: 70),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 70,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextBold(str: title, size: 20, color: AppColor.black),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextRegular(
              str: message,
              size: 15,
              align: 2,
              color: AppColor.color_B0B0B0,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            child: ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getAICheck() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.only(top: 10.0, left: 3, right: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            style: const TextStyle(color: Colors.white, letterSpacing: 1.0),
            children: [
              const TextSpan(
                text: '@TIFIN AI ASSISTANT MAY NOT ALWAYS BE ACCURATE. ',
                style: const TextStyle(fontSize: 12, color: AppColor.white),
              ),
              TextSpan(
                text: 'CHECK IMPORTANT DETAILS',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.white,
                  decorationColor: AppColor.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
