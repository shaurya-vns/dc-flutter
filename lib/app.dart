import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'localization/app_localization.dart';
import 'splash.dart';
import 'src/config/app_config.dart';
import 'src/constants/color_constants.dart';

Future<void> runWithAppConfig(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // await Firebase.initializeApp(options: appConfig.options);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      EasyLocalization(
        supportedLocales: AppLocalization.all,
        path: 'assets/translations',
        fallbackLocale: AppLocalization.localMatched() ?? AppLocalization.all[0],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      color: AppColor.white,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.transparent,
          cursorColor: AppColor.color_D25B17,
          selectionHandleColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: AppColor.color_D25B17),
        primaryColor: AppColor.color_D25B17,
        secondaryHeaderColor: AppColor.color_D25B17,
      ),
      // home: const SplashPage(),
      home: const SplashPage(),
    );
  }
}
