import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/custome_line.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';

class AIPage extends StatefulWidget {
  const AIPage({Key? key}) : super(key: key);

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF4A3AFF)],
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.smart_toy, color: Colors.white, size: 25),
                            ),
                            SizedBox(width: 16),
                            TextSemi(
                              str: 'AI Food Assistant\nHow can I help today?',
                              color: AppColor.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      Gap(h: 20),
                      FixButtonWidget(
                        height: 58,
                        radius: 30,
                        color: AppColor.white,
                        borderColor: AppColor.white,
                        onPressed: () {},
                        child: Row(
                          children: [
                            Gap(w: 30),
                            Expanded(
                              child: TextSemi(
                                str: 'Ask AI anything...',
                                size: 17,
                                color: AppColor.black,
                              ),
                            ),

                            Icon(Icons.send, color: Colors.black, size: 25),
                            Gap(w: 16),
                          ],
                        ),
                      ),

                      Gap(h: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _actionCard(
                              Icons.restaurant,
                              "Meal Plan",
                              Colors.green,
                            ),
                          ),
                          Gap(w: 10),
                          Expanded(
                            child: _actionCard(
                              Icons.shopping_bag,
                              "Orders",
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Gap(h: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _actionCard(
                              Icons.subscriptions,
                              "Subscription",
                              Colors.purple,
                            ),
                          ),
                          Gap(w: 10),
                          Expanded(
                            child: _actionCard(Icons.analytics, "Analytics", Colors.blue),
                          ),
                        ],
                      ),

                      Gap(h: 30),
                      _sectionTitle("AI Recommendation"),
                      Gap(h: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.amber),
                            Gap(w: 15),
                            TextSemi(
                              str:
                                  'Today\'s recommended meal:\nPaneer Butter Masala + Roti + Salad',
                              size: 17,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                      Gap(h: 30),
                      _sectionTitle("Active Order"),
                      Gap(h: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.delivery_dining, color: Colors.green),
                                SizedBox(width: 10),
                                TextSemi(
                                  str: 'Order #12345',
                                  color: AppColor.white,
                                  size: 18,
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            LinearProgressIndicator(value: .75),
                            SizedBox(height: 10),
                            TextRegular(
                              str: 'Estimated Delivery: 18 mins',
                              color: AppColor.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      Gap(h: 30),
                      _sectionTitle("Subscription"),
                      Gap(h: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C896), Color(0xFF06D6A0)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBold(
                              str: 'Premium Veg Plan',
                              color: AppColor.white,
                              size: 20,
                            ),
                            Gap(h: 6),
                            TextRegular(
                              str: '25 meals remaining',
                              color: AppColor.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Gap(h: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _widgetHeader(),
                ),
                Gap(h: 10),
                CustomLine(),
                Gap(h: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetHeader() {
    return Row(
      children: [
        Expanded(child: TextSemi(str: 'Good AI, 👋', size: 20, color: AppColor.black)),
        RoundedContainer(w: 35, h: 35, color: AppColor.color_B0B0B0, rounded: 40),
      ],
    );
  }

  static Widget _actionCard(IconData icon, String title, Color color) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.white, AppColor.white],
        ),
        boxShadow: [
          BoxShadow(color: Color(0x33FF5722), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          Gap(h: 10),
          TextMedium(str: title, size: 20, color: AppColor.black),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextSemi(str: title, color: AppColor.black, size: 20),
    );
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {}
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
