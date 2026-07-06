import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/coach/StationListPage.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';

class SplashCoachPage extends StatefulWidget {
  const SplashCoachPage({super.key});

  @override
  State<SplashCoachPage> createState() => _SplashCoachPageState();
}

class _SplashCoachPageState extends State<SplashCoachPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      AppUtils.launchScreen(context, StationListPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    SCREEN_WIDTH = MediaQuery.of(context).size.width;
    SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff22C55E), Color(0xff0F9D58)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 35),

            const Text(
              "Coach App",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 35,
              height: 35,
              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
