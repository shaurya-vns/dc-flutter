import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String DATE_FORMAT = 'dd MMM, yyyy';

  // "2026-01-12T06:14:49.000Z"
  static String parseDateBy(String? input) {
    //26/06/2026 at 6:00 pm
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('dd/MM/yyyy \'at\' h:mm a').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDate(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('dd MMM, yyyy').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDate2(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('MMM d').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDate3(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('HH:mm a').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDate4(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('EEE, MMM dd, yyyy HH:mma').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDate5(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('MMM d, y').format(dtLocal);
      return formatted;
    } catch (e) {}
    return '';
  }

  static String parseDate6(String? input) {
    // String input = "2025-11-17T04:52:25.000Z";
    try {
      DateTime dtUtc = DateTime.parse(input!);
      DateTime dtLocal = dtUtc.toLocal();
      String formatted = DateFormat('dd-MM-yyyy').format(dtLocal);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static Future<void> pickDate(
    BuildContext context,
    Function(DateTime date) callback,
  ) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      callback(selectedDate);
    }
  }

  static int calculateAge(String birthDateString) {
    int age = 0;
    try {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime today = DateTime.now();
      age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
    } catch (e) {}
    return age;
  }

  static int dayFromDate(String? isoDateString) {
    int daysDifference = 1;
    try {
      DateTime givenDate = DateTime.parse(isoDateString!);
      DateTime now = DateTime.now().toUtc();
      Duration diff = now.difference(givenDate);
      daysDifference = diff.inDays;
    } catch (e) {}

    return daysDifference;
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  static String parseDate7(String? str) {
    try {
      DateTime dtUtc = DateTime.parse(str!);
      DateTime date = dtUtc.toLocal();
      String getDaySuffix(int day) {
        if (day >= 11 && day <= 13) return 'th';

        switch (day % 10) {
          case 1:
            return 'st';
          case 2:
            return 'nd';
          case 3:
            return 'rd';
          default:
            return 'th';
        }
      }

      final day = date.day;
      final suffix = getDaySuffix(day);
      return '$day$suffix ${DateFormat('MMMM').format(date)}';
    } catch (e) {}
    return 'NA';
  }

  static String parseDateTime(DateTime input) {
    try {
      String formatted = DateFormat('dd MMMM, yyyy').format(input);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String parseDateApi(DateTime input) {
    try {
      String formatted = DateFormat('yyyy-MM-dd').format(input);
      return formatted;
    } catch (e) {}
    return 'NA';
  }

  static String getDisplayTitle(String? date, String? mealType) {
    if (AppUtils.isBlank(date)) return '';

    final mealDate = DateTime.parse(date!);
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(mealDate.year, mealDate.month, mealDate.day);

    String dayText;

    if (target == today) {
      dayText = "Today";
    } else if (target == today.add(const Duration(days: 1))) {
      dayText = "Tomorrow";
    } else {
      dayText = TimeUtils.parseDate2(date);
    }
    String mealText;

    switch (mealType!.toLowerCase()) {
      case "breakfast":
        mealText = "Morning";
        break;
      case "lunch":
        mealText = "Afternoon";
        break;
      case "dinner":
        mealText = "Night";
        break;
      default:
        mealText = mealType;
    }

    return "$dayText ($mealText)";
  }

  static String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
}
