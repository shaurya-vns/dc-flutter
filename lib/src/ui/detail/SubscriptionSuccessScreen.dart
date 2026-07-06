import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';

class SubscriptionSuccessScreen extends StatefulWidget {
  final String subscriptionId;
  final int type;

  const SubscriptionSuccessScreen({
    super.key,
    required this.type,
    required this.subscriptionId,
  });

  @override
  State<SubscriptionSuccessScreen> createState() => _SubscriptionSuccessScreenState();
}

class _SubscriptionSuccessScreenState extends State<SubscriptionSuccessScreen> {
  int _seconds = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Confetti
    Future.delayed(const Duration(milliseconds: 300), () {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 150, spread: 100, y: 0.6),
      );
    });

    // Countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        _goHome();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _goHome() {
    AppUtils.launchScreenRemoveAll(context, DashboardPage());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F5E9), Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                /// 🎉 Success Icon
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade100,
                    boxShadow: [
                      BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 70, color: Colors.green),
                ),

                const SizedBox(height: 25),

                /// Title
                Text(
                  widget.type == 1
                      ? "Your Subscription\nhas been Created!"
                      : "Your Order\nhas been Created!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.type == 1
                      ? "Thank you for choosing us.\nYour meal plan is now active."
                      : "Thank you for choosing us.\nYour order is now preparing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 25),

                /// Subscription Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.type == 1 ? "Subscription Number:" : "Order Number:",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.subscriptionId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Countdown
                Text(
                  "Redirecting in $_seconds seconds...",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),
                TextButton(
                  onPressed: _goHome,
                  child: const Text("Back to Home", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
