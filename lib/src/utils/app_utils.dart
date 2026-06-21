import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';
import 'app_constant.dart';
import 'ext.dart';
import 'preference_util.dart';
import 'widgetUtils.dart';

class AppUtils {
  static double fontSize = 1;

  static Future<void> fontValue() async {
    var d = await PreferenceUtil.getFontSize();
    if (d > .5) {
      fontSize = d;
    } else {
      fontSize = 1;
    }
  }

  static void hideKeyboard(context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static Future<bool> isNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      } else {
        AppUtils.showToast(AppConstants.no_network);
        return false;
      }
    } on SocketException catch (_) {
      AppUtils.showToast(AppConstants.no_network);
      return false;
    }
  }

  static launchScreen(context, screen) {
    hideKeyboard(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static launchScreenRemoveAll(context, screen) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => screen),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  static launchScreenWithResult(context, screen) async {
    final valueFromSecondScreen = await Navigator.of(context).push<Object>(
      MaterialPageRoute(
        builder: (context) {
          return screen;
        },
      ),
    );

    return valueFromSecondScreen;
  }

  /* static fcmDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    DEVICE_TOKEN = token ?? "";
    PreferenceUtil.setDeviceToken(DEVICE_TOKEN);
    print("TTTTTTTTTT ${token}");
  }*/

  static String firstChar(String? str) {
    if (str != null && str.isNotEmpty) {
      return str
          .toLowerCase()
          .split(' ')
          .map((word) {
            String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
            return word[0].toUpperCase() + leftText;
          })
          .join(' ');
    }
    return '--';
  }

  static String formattedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  static bool isNotValidEmail(String email) {
    return !RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  //

  static String s = '';

  static bool isNotValidPassword(String password) {
    return !RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(){}|?<>,.;:`"~_+\-=\[\]])[A-Za-z\d!@#$%^&*(){}|\\?/<>,.;:~_+\-=\[\]]{8,}$',
    ).hasMatch(password);
  }

  static void showToast(String? msg) {
    if (msg?.isNotEmpty == true) {
      Fluttertoast.showToast(
        msg: msg!,
        backgroundColor: AppColor.black,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 17.0,
      );
    }
  }

  static void popScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  static String getNameFirst(String? firstName) {
    String name = '';
    if (firstName?.isNotEmpty == true) {
      name = firstName?[0].toCapitalized() ?? '-';
    }
    return name.toTitleCase();
  }

  static String getName(String? firstName, String? lastName, {bool isCaps = false}) {
    String name = '';
    if (firstName?.isNotEmpty == true) {
      name = firstName!.toTitleCase();
    }
    if (lastName?.isNotEmpty == true) {
      name = '${name} ${lastName?.toTitleCase()}';
    }
    if (isCaps) {
      return name.toUpperCase();
    }
    return name;
  }

  static int currentYear() {
    return DateTime.now().year;
  }

  static String getIndex(int index) {
    var d = index + 1;
    return d > 9 ? '$d' : '0$d';
  }

  static Future<void> openInBrowser(String? url) async {
    if (url?.isNotEmpty == true) {
      final Uri uri = Uri.parse(url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in YouTube app or browser
        );
      } else {
        AppUtils.showToast('Url can be open');
      }
    } else {
      AppUtils.showToast('Url can be open');
    }
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
              fontSize: 12,
              color: AppColor.red,
              fontFamily: Fonts.REGULAR,
            ),
          );
        }
      },
    );
  }

  static String formatPrice(
    double? amount, {
    String locale = 'en_US',
    String currencyCode = 'USD',
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      symbol: '₹', // or set symbol like '₹', '$' if you prefer
      decimalDigits: 0, // decimals
    );
    if (amount == null || amount < 0) {
      amount = 0;
    }
    return format.format(amount);
  }

  static int getInt4(String? str) {
    int name = 0;
    if (str == null) {
      return name;
    }
    return int.tryParse(str) ?? 0;
  }
}
