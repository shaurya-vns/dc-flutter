import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dc/src/utils/AppStatus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';
import '../model/response/address/AddressModel.dart';
import 'app_constant.dart';

class AppUtils {
  static void hideKeyboard(context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static bool isBlank(String? str2) {
    return str2 == null || str2 == 'null' || str2.length == 0 || str2.trim().length == 0;
  }

  static bool isNotBlank(String? str2) {
    return !(str2 == null || str2 == 'null' || str2.isEmpty || str2.trim().isEmpty);
  }

  static bool isDoubleBlank(double? str2) {
    return (str2 == null || str2 == 0);
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

  static String getFirstValue(String? name) {
    if (AppUtils.isNotBlank(name)) {
      if (name!.trim().isEmpty) return '';

      List<String> words =
          name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

      return words.map((word) => word[0].toUpperCase()).join();
    }
    return '';
  }

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

  static int getInt3(String? str) {
    int name = 0;

    try {
      name = int.tryParse(str!) ?? 0;
    } catch (e) {}
    return name;
  }

  static String getStr(String? str) {
    String name = '';
    if (AppUtils.isBlank(str)) {
      return name;
    }
    return str!;
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
      decimalDigits: 1, // decimals
    );
    if (amount == null || amount < 0) {
      amount = 0;
    }
    return format.format(amount);
  }

  static void navigateWebLink(String? webLink) async {
    if (webLink?.isNotEmpty == true) {
      final Uri uri = Uri.parse(webLink!);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in external browser
      )) {
        throw 'Could not launch $webLink';
      }
    }
  }

  static Future<void> navigateEmail({
    required String? toEmail,
    String subject = 'Request new Employer Sponsor',
    String body = '',
  }) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      queryParameters: {'subject': subject, 'body': body},
    );

    // Check first if the URL can be launched
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Show Toast instead of throwing error
      Fluttertoast.showToast(
        msg: "No email client installed or not supported on this device.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    }
  }

  static Future<void> openPhoneDialer(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  static Future<void> openWhatsApp(String phone) async {
    final uri = Uri.parse("https://wa.me/$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static int getInt(int? str) {
    int name = 0;
    if (str == null) {
      return name;
    }
    return str;
  }

  static int getInt4(String? str) {
    int name = 0;
    if (str == null) {
      return name;
    }
    return int.tryParse(str) ?? 0;
  }

  static String getStr2(int? str) {
    if (str == null) {
      return '';
    }
    return '$str';
  }

  static String getStr3(double? str) {
    if (str == null) {
      return '';
    }
    return '$str';
  }

  static double getDouble(double? str) {
    double name = 0;
    if (str == null) {
      return name;
    }
    return str;
  }

  static double getDouble2(String? str) {
    double name = 0;
    if (str == null) {
      return name;
    }
    return double.tryParse(str) ?? 0;
  }

  static Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColor.white;

    hex = hex.replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF$hex";
    }

    return Color(int.parse(hex, radix: 16));
  }

  static Widget getError(String str) {
    return Text(
      str,
      style: const TextStyle(
        fontSize: 14,
        color: AppColor.red,
        fontFamily: Fonts.REGULAR,
      ),
    );
  }

  static Widget widgetGetErrorUI(StreamController<String> stream) {
    return StreamBuilder<String>(
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
          String error = snapshot.data ?? '';
          return Container(child: getError(error));
        } else {
          return const Text(
            '',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.red,
              fontFamily: Fonts.REGULAR,
            ),
          );
        }
      },
    );
  }

  static int getLength(int? s) {
    if (s == null) {
      return 0;
    }
    return s;
  }

  static Future<void> shareOnWhatsApp(String message) async {
    final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  static void copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  static bool isToken() {
    return isNotBlank(ACCESS_TOKEN);
  }

  static String getStaticMapUrl({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    return "https://maps.googleapis.com/maps/api/staticmap"
        "?size=800x400"
        "&maptype=roadmap"
        "&markers=color:green|$fromLat,$fromLng"
        "&markers=color:red|$toLat,$toLng"
        "&path=color:0x0000ff|weight:5|$fromLat,$fromLng|$toLat,$toLng"
        "&key=AIzaSyB8IJZnOcXqKeHO7xcHimVN_gBku6L47tw";
  }

  static String getFileNameFromUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }

    return Uri.parse(url).pathSegments.last;
  }

  static String getFirstImage(List<String>? images) {
    if (images?.isEmpty == true) return '';
    return images?[0] ?? '';
  }

  static String formatStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return 'NA';
    }

    return status
        .trim()
        .toLowerCase()
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  static String getMealSummary(String? mealType, int? quantity) {
    const mealMap = {
      "breakfast": ["Morning"],
      "lunch": ["Afternoon"],
      "dinner": ["Night"],
      "breakfast_lunch": ["Morning", "Afternoon"],
      "breakfast_dinner": ["Morning", "Night"],
      "lunch_dinner": ["Afternoon", "Night"],
      "breakfast_lunch_dinner": ["Morning", "Afternoon", "Night"],
    };

    final meals = mealMap[mealType] ?? [];
    final totalThalis = meals.length * quantity!;

    if (meals.length == 1) {
      return "$quantity Thali${quantity > 1 ? 's' : ''} in ${meals.first}";
    }

    return "$totalThalis Thali${totalThalis > 1 ? 's' : ''} per day";
  }

  static String getDistance(AddressModel? owner, AddressModel? user) {
    if (owner == null || user == null) return '';
    double lat1 = AppUtils.getDouble(owner.latitude);
    double lon1 = AppUtils.getDouble(owner.longitude);
    double lat2 = AppUtils.getDouble(user.latitude);
    double lon2 = AppUtils.getDouble(user.longitude);

    double distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return formatDistance(distanceInMeters);
  }

  static String formatDistance(num distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    }

    final km = distanceInMeters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  static String getHomeAddress(AddressModel? address) {
    if (address != null) {
      return address.addressTypeLabel;
    }
    return 'Home';
  }

  static String getFullAddress(AddressModel? address) {
    if (AppUtils.isNotBlank(address?.fullAddress)) {
      return address?.fullAddress ?? 'Add Address';
    }
    return 'Add Address';
  }

  static AddressModel? getDefaultAddress(List<AddressModel>? list) {
    AddressModel? defaultAddress;
    if (list != null && list.isNotEmpty) {
      final filtered = list.where((item) => item.isDefault == true).toList();
      if (filtered.isNotEmpty) {
        defaultAddress = filtered.first;
      }
    }
    return defaultAddress;
  }

  static bool isUser() {
    return USER_DATA?.userType == UserType.USER;
  }
}
