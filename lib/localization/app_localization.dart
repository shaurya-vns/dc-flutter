import 'dart:ui' as ui;
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class AppLocalization {
  static final all = [const Locale('en'), const Locale('es')];

  static Locale? localMatched() {
    Locale? locale;
    Locale? systemLocale = ui.PlatformDispatcher.instance.locale;
    String languageCode = systemLocale.languageCode ?? '';
    String countryCode = systemLocale.countryCode ?? '';
    if (kDebugMode) {
      print('App : languageCode->{$languageCode countryCode->{$countryCode}');
    }

    for (var element in all) {
      if (languageCode == element.languageCode) {
        locale = element;
        break;
      }
    }

    /*  switch (locale?.languageCode) {
      case 'en':
        {
          PreferenceUtil.setLanguage(LocaleKeys.english.tr());
          break;
        }
      case 'es':
        {
          PreferenceUtil.setLanguage(LocaleKeys.spanish.tr());
          break;
        }
    }*/
    return locale;
  }
}
