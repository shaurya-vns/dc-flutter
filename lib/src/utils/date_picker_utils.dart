import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';

import '../constants/color_constants.dart';

class DatePickerUtils {
  static Future<void> selectCalendar({
    required BuildContext context,
    bool isPreviousDate = false,
    bool isNextDate = false,
    String? blockDate,
    int fromDate = 0,
    required Function(String? uiDate, String? apiDate) onDateCallback,
  }) async {
    print('date blockDate $blockDate');

    var firstDate = DateTime.now().add(Duration(days: 0));
    var lastDate = DateTime.now();
    try {
      firstDate =
          isPreviousDate == true
              ? DateTime(1900, 1)
              : DateTime.now().add(Duration(days: fromDate));
    } catch (e) {
      print('date error $e');
    }

    print('date firstDate $firstDate');

    try {
      if (isNextDate == true) {
        lastDate = lastDate;
      } else {
        lastDate = DateTime(DateTime.monthsPerYear + 2230);
      }
    } catch (e) {}

    print('date lastDate $lastDate');

    final DateTime? date = await showDatePicker(
      locale: Locale('en'),
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: AppColor.black,
            hintColor: AppColor.black,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            datePickerTheme: const DatePickerThemeData(
              headerBackgroundColor: AppColor.white,
              backgroundColor: AppColor.white,
              headerForegroundColor: AppColor.black,
              surfaceTintColor: AppColor.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      var uiDate1 = TimeUtils.parseDateTime(date);
      var apiDate = TimeUtils.parseDateApi(date);
      onDateCallback(uiDate1, apiDate);
    }
  }

  static Future<void> selectCalendarOnly({
    required BuildContext context,
    required Function(String? uiDate, String? apiDate) onDateCallback,
  }) async {
    final DateTime today = DateTime.now();

    final DateTime? date = await showDatePicker(
      context: context,
      locale: const Locale('en'),

      initialDate: today,

      firstDate: DateTime(today.year, today.month, today.day),

      lastDate: DateTime(today.year, today.month, today.day).add(const Duration(days: 2)),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: AppColor.white,
              surfaceTintColor: AppColor.white,
              headerBackgroundColor: AppColor.white,
              headerForegroundColor: AppColor.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      onDateCallback(TimeUtils.parseDateTime(date), TimeUtils.parseDateApi(date));
    }
  }
}
