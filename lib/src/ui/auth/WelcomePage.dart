import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/auth/login/login_page.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';

import '../../utils/app_constant.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Top Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff22C55E), Color(0xff16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(blurRadius: 18, color: Colors.black.withOpacity(.15)),
                        ],
                      ),
                      child: const Icon(
                        Icons.lunch_dining,
                        color: Colors.green,
                        size: 70,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Fresh Homemade\nTiffin Everyday",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Healthy meals prepared with love\nand delivered fresh to your doorstep.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Feature Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: const [
                    Expanded(child: FeatureCard(icon: Icons.restaurant, title: "Fresh")),

                    SizedBox(width: 12),

                    Expanded(
                      child: FeatureCard(icon: Icons.delivery_dining, title: "Fast"),
                    ),

                    SizedBox(width: 12),

                    Expanded(child: FeatureCard(icon: Icons.favorite, title: "Healthy")),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Continue As",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoleCard(
                  title: "Customer",
                  subtitle: "Order delicious homemade meals",
                  icon: Icons.person,
                  color: Colors.green,
                  onTap: () {
                    AppUtils.launchScreen(context, LoginPage(userType: UserType.USER));
                  },
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoleCard(
                  title: "Sub Owner",
                  subtitle: "Manage products & customer orders",
                  icon: Icons.storefront,
                  color: Colors.orange,
                  onTap: () {
                    AppUtils.launchScreen(
                      context,
                      LoginPage(userType: UserType.SUB_OWNER),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.05))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 34),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.06))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color, size: 30),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, color: color, size: 15),
          ],
        ),
      ),
    );
  }
}
