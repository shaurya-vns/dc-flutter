import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/auth/WelcomePage.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';
import 'package:flutter_dc/src/ui/owner/dashboard/sub_owner_dashboard_page.dart';

import 'src/utils/app_constant.dart';
import 'src/utils/app_utils.dart';
import 'src/utils/preference_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _steamController;

  late Animation<double> _scale;
  late Animation<double> _steam;

  getToken() async {
    ACCESS_TOKEN = await PreferenceUtil.getAccessToken();
    USER_DATA = await PreferenceUtil.userProfile();
    print('ACCESS_TOKEN $ACCESS_TOKEN');
  }

  @override
  void initState() {
    super.initState();
    getToken();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut);

    _steam = Tween<double>(
      begin: 0,
      end: -25,
    ).animate(CurvedAnimation(parent: _steamController, curve: Curves.easeInOut));

    _logoController.forward();
    _steamController.repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      if (AppUtils.isNotBlank(ACCESS_TOKEN)) {
        if (USER_DATA?.userType == UserType.SUB_OWNER) {
          AppUtils.launchScreenRemoveAll(context, SubOwnerDashboardPage());
        } else {
          AppUtils.launchScreenRemoveAll(context, DashboardPage());
        }
      } else {
        AppUtils.launchScreen(context, WelcomePage());
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _steamController.dispose();
    super.dispose();
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
        child: AnimatedBuilder(
          animation: Listenable.merge([_logoController, _steamController]),
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Steam
                Transform.translate(
                  offset: Offset(0, _steam.value),
                  child: const Text("♨️", style: TextStyle(fontSize: 40)),
                ),

                const SizedBox(height: 5),

                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: const Icon(Icons.lunch_dining, color: Colors.green, size: 75),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Daily Tiffin",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Fresh • Healthy • Homemade",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),

                const SizedBox(height: 50),

                const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
