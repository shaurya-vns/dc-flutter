import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/auth/login/login_page.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';

import '../../utils/app_constant.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 45),

              _buildFeatureSection(),

              const SizedBox(height: 45),

              _buildLoginButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    const double orbitRadius = 78;

    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          final angle = _rotationController.value * 2 * pi;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// Outer Circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.15),
                ),
              ),

              /// Main Circle
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.18)),
                  ],
                ),
                child: const Icon(
                  Icons.dinner_dining_sharp,
                  size: 65,
                  color: Colors.green,
                ),
              ),

              /// ❤️ Heart Orbit
              Transform.translate(
                offset: Offset(orbitRadius * cos(angle), orbitRadius * sin(angle)),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.emoji_food_beverage_outlined,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),

              /// 🔥 Fire Orbit
              Transform.translate(
                offset: Offset(
                  orbitRadius * cos(angle + pi),
                  orbitRadius * sin(angle + pi),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff22C55E), Color(0xff16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 45),
          _buildHeroImage(),
          const SizedBox(height: 20),
          const Text(
            "Fresh Homemade\nTiffin Everyday",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Healthy meals prepared with love\nDelivered fresh at your doorstep.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: const [
          Expanded(child: FeatureCard(icon: Icons.restaurant, title: "Fresh")),

          SizedBox(width: 12),

          Expanded(child: FeatureCard(icon: Icons.delivery_dining, title: "Fast")),

          SizedBox(width: 12),

          Expanded(child: FeatureCard(icon: Icons.favorite, title: "Healthy")),
        ],
      ),
    );
  }

  Widget _statItem(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 6),

        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade300);
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          AppUtils.launchScreen(context, LoginPage(userType: UserType.USER));
        },
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff22C55E), Color(0xff16A34A)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(blurRadius: 18, color: Colors.green.withOpacity(.35))],
          ),
          child: const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green),
            ),
            title: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Customer • Vendor • Delivery",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward, color: Colors.green),
            ),
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
