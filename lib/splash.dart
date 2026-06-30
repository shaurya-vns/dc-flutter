import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/auth/login/login_page.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';

import 'src/constants/color_constants.dart';
import 'src/constants/drawable_constant.dart';
import 'src/utils/app_constant.dart';
import 'src/utils/app_utils.dart';
import 'src/utils/log.dart';
import 'src/utils/preference_util.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool isLogin = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getToken();
    Timer(const Duration(seconds: 3), () {
      Log.i('isLogin $isLogin');
      if (AppUtils.isNotBlank(ACCESS_TOKEN)) {
        AppUtils.launchScreenRemoveAll(context, DashboardPage());
      } else {
        AppUtils.launchScreen(context, LoginPage());
      }
    });
  }

  getToken() async {
    ACCESS_TOKEN = await PreferenceUtil.getAccessToken();
    USER_DATA = await PreferenceUtil.userProfile();
    print('ACCESS_TOKEN $ACCESS_TOKEN');
  }

  @override
  Widget build(BuildContext context) {
    SCREEN_WIDTH = MediaQuery.of(context).size.width;
    SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.color_041526,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: AppColor.color_041526),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: Image.asset(width: SCREEN_WIDTH, DrawableConstant.ic_down),
          ),
        ),
      ),
    );
  }
}
