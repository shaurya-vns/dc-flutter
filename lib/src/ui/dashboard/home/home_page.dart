import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/ui/detail/subscription_page.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/fix_button_widget.dart';
import '../../common_bloc.dart';
import '../../detail/meal_page.dart';
import '../menu/menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetTodayPlan(),
                    Gap(h: 20),
                    _widgetActiveSubscription(),
                    Gap(h: 30),
                    _widgetPlan(),
                    Gap(h: 10),
                    _widgetPlanList(),
                    Gap(h: 30),
                    _widgetSubscriptionMeals(),
                    Gap(h: 10),
                    _widgetListSubscriptionMealsUI(),
                    Gap(h: 30),
                    _widgetPerDayMeals(),
                    Gap(h: 10),
                    _widgetPerDayListUI(),
                    Gap(h: 30),
                    _widgetHealthy(),
                    Gap(h: 10),
                    _widgetHealthyList(),
                    Gap(h: 10),
                    MenuWidget(),
                  ],
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
        Expanded(
          child: TextSemi(str: 'Good Morning, Umesh 👋', size: 20, color: AppColor.black),
        ),
        RoundedContainer(w: 35, h: 35, color: AppColor.color_B0B0B0, rounded: 40),
      ],
    );
  }

  Widget _widgetTodayPlan() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBold(
            str: 'Today\'s Serving'.toUpperCase(),
            size: 16,
            color: AppColor.black,
          ),
          Gap(h: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.white, AppColor.white],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.colorBlue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                      child: Image.asset(
                        DrawableConstant.ic_test,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 140,
                      ),
                    ),
                    Gap(w: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(h: 4),
                          TextSemi(
                            str: 'Paneer Butter Masala Meal',
                            color: AppColor.black,
                            size: 20,
                          ),
                          Gap(h: 4),
                          TextSemi(
                            str: '🍽 Lunch | Preparing',
                            color: AppColor.color_0A1B35,
                            size: 15,
                          ),
                          Gap(h: 3),
                          TextRegular(
                            str: 'Paneer • Roti • Salad',
                            color: AppColor.black,
                            size: 14,
                          ),
                          Gap(h: 3),
                          TextMedium(
                            str: '🕐 ETA: 35 mins',
                            color: AppColor.color_DE6262,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    Gap(w: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetActiveSubscription() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBold(str: '⭐ ACTIVE SUBSCRIPTION ', size: 17, color: AppColor.black),
          Gap(h: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.white, AppColor.white],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33FF5722),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(h: 4),
                  TextBold(
                    str: 'Premium Veg Plan ║ ₹3,999 / Month',
                    size: 20,
                    color: AppColor.black,
                  ),
                  TextSemi(str: '🍽 3 Meals Daily', size: 15, color: AppColor.black),
                  Gap(h: 15),
                  CustomLine(),
                  Gap(h: 15),
                  TextBold(
                    str: 'Today\'s Serving'.toUpperCase(),
                    size: 16,
                    color: AppColor.black,
                  ),
                  Gap(h: 5),
                  TextSemi(
                    str: 'Paneer Butter Masala Meal',
                    size: 15,
                    color: AppColor.black,
                  ),
                  Gap(h: 3),
                  TextMedium(str: 'Lunch', size: 15, color: AppColor.black),
                  Gap(h: 3),
                  TextRegular(
                    str: 'Paneer • Roti • Salad     ',
                    size: 15,
                    color: AppColor.black,
                  ),
                  Gap(h: 3),
                  TextRegular(
                    str: 'ETA: 35 mins',
                    size: 15,
                    color: AppColor.color_D25B17,
                  ),
                  Gap(h: 15),
                  CustomLine(),
                  Gap(h: 15),
                  Container(
                    alignment: Alignment.topLeft,
                    color: AppColor.trans,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBold(
                          str: '🚚 NEXT DELIVERY',
                          color: AppColor.black,
                          size: 14,
                        ),
                        Gap(h: 5),
                        TextMedium(str: 'Dinner', size: 15, color: AppColor.black),
                        Gap(h: 3),
                        TextRegular(
                          str: 'Paneer • Roti • Salad • Sweets  ',
                          size: 15,
                          color: AppColor.black,
                        ),
                        Gap(h: 3),
                        TextRegular(
                          str: 'ETA: 4 hours',
                          size: 15,
                          color: AppColor.color_D25B17,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetPlan() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(str: 'Plan (4)'.toUpperCase(), color: AppColor.black, size: 20),
    );
  }

  Widget _widgetPlanList() {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: SCREEN_WIDTH - 40,
              child: CustomCard(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(h: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextSemi(
                        str: 'Daily Ghar Ka Khana Plans',
                        color: AppColor.black,
                        size: 18,
                      ),
                    ),
                    Gap(h: 15),
                    Image.asset(
                      DrawableConstant.ic_test,
                      fit: BoxFit.cover,
                      width: SCREEN_WIDTH,
                      height: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(h: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextRegular(
                                str: '4+ items',
                                color: AppColor.black,
                                size: 16,
                              ),
                              Gap(w: 15),
                              Container(width: 0.5, height: 10, color: AppColor.black),
                              Gap(w: 15),
                              Image.asset(
                                DrawableConstant.ic_star,
                                color: AppColor.color_F4C102,
                                width: 17,
                                height: 17,
                              ),
                              Gap(w: 10),
                              TextSemi(str: '4.7', color: AppColor.black, size: 16),
                            ],
                          ),
                          Gap(h: 3),
                          Row(
                            children: [
                              TextSemi(
                                str: 'Basic Price: ',
                                color: AppColor.black,
                                size: 16,
                              ),
                              TextBold(
                                str: AppUtils.formatPrice(3000),
                                color: AppColor.black,
                                size: 16,
                              ),
                              TextBold(str: ' - ', color: AppColor.black, size: 16),
                              TextBold(
                                str: AppUtils.formatPrice(4000),
                                color: AppColor.black,
                                size: 16,
                              ),
                            ],
                          ),

                          Gap(h: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FillButtonWidget(
                                width: 230,
                                bgColor: AppColor.red,
                                title: 'Select Plan',
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Gap(h: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetSubscriptionMeals() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(
        str: 'Subscription (10+)'.toUpperCase(),
        color: AppColor.black,
        size: 20,
      ),
    );
  }

  Widget _widgetListSubscriptionMealsUI() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 0),
            child: SizedBox(
              width: SCREEN_WIDTH - 40,
              child: CustomCard(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          DrawableConstant.ic_test,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 110,
                        ),
                        Gap(w: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(h: 10),
                              TextSemi(
                                str: 'Comfort Dinner wq eqw eqw eqwe',
                                color: AppColor.black,
                                size: 17,
                              ),
                              Gap(h: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    DrawableConstant.ic_star,
                                    color: AppColor.color_F4C102,
                                    width: 16,
                                    height: 16,
                                  ),
                                  Gap(w: 10),
                                  TextSemi(str: '4.7', color: AppColor.black, size: 16),
                                ],
                              ),
                              Gap(h: 6),
                              TextSemi(
                                str: '4 Roti | Dal | Salad | Sweets',
                                color: AppColor.color_0A1B35,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(h: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextSemi(
                        str: 'Subscribe for',
                        color: AppColor.colorBlue,
                        size: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Gap(w: 30),
                        TextMedium(
                          str: '20 days | ',
                          color: AppColor.color_0A1B35,
                          size: 16,
                        ),
                        TextMedium(
                          str: '25 days | ',
                          color: AppColor.color_0A1B35,
                          size: 16,
                        ),
                        TextMedium(
                          str: '30 days',
                          color: AppColor.color_0A1B35,
                          size: 16,
                        ),
                      ],
                    ),
                    Gap(h: 10),
                    Row(
                      children: [
                        Gap(w: 15),
                        TextBold(
                          str: AppUtils.formatPrice(3000),
                          color: AppColor.black,
                          size: 18,
                        ),
                        TextBold(str: ' - ', color: AppColor.black, size: 18),
                        TextBold(
                          str: AppUtils.formatPrice(4000),
                          color: AppColor.black,
                          size: 18,
                        ),
                      ],
                    ),
                    Gap(h: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FillButtonWidget(
                          width: 230,
                          bgColor: AppColor.red,
                          title: 'Subscribe Meal',
                          onPressed: () {
                            AppUtils.launchScreen(context, SubscriptionPage());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetPerDayMeals() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(
        str: 'Meals Per Day (10+)'.toUpperCase(),
        color: AppColor.black,
        size: 20,
      ),
    );
  }

  Widget _widgetPerDayListUI() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 0),
            child: SizedBox(
              width: SCREEN_WIDTH - 40,
              child: CustomCard(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(w: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(h: 10),
                              TextSemi(
                                str: 'Comfort Dinner',
                                color: AppColor.black,
                                size: 17,
                              ),
                              Gap(h: 5),
                              TextRegular(
                                str: '(Only Dinner) Light yet satisfying evening meals',
                                color: AppColor.black,
                                size: 13,
                              ),
                              Gap(h: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    DrawableConstant.ic_star,
                                    color: AppColor.color_F4C102,
                                    width: 16,
                                    height: 16,
                                  ),
                                  Gap(w: 10),
                                  TextSemi(str: '4.7', color: AppColor.black, size: 16),
                                ],
                              ),
                              Gap(h: 6),
                              TextSemi(
                                str: '4 Roti | Dal | Salad | Sweets',
                                color: AppColor.color_0A1B35,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                        Gap(w: 3),
                        Image.asset(
                          DrawableConstant.ic_test,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 110,
                        ),
                      ],
                    ),
                    Gap(h: 10),
                    Row(
                      children: [
                        Gap(w: 15),
                        TextBold(str: 'Per day: ', color: AppColor.black, size: 18),
                        TextBold(str: ' ', color: AppColor.black, size: 18),
                        TextBold(
                          str: AppUtils.formatPrice(4000),
                          color: AppColor.black,
                          size: 18,
                        ),
                      ],
                    ),
                    Gap(h: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FillButtonWidget(
                          width: 230,
                          bgColor: AppColor.red,
                          title: 'Choose Meal',
                          onPressed: () {
                            AppUtils.launchScreen(context, MealPage());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetHealthy() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(
        str: 'Healthy Meals (10+)'.toUpperCase(),
        color: AppColor.black,
        size: 20,
      ),
    );
  }

  Widget _widgetHealthyList() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 0),
            child: SizedBox(
              width: SCREEN_WIDTH - 40,
              child: CustomCard(
                elevation: 1,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.asset(
                      DrawableConstant.text_2,
                      fit: BoxFit.cover,
                      width: SCREEN_WIDTH,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColor.trans,
                            AppColor.black.withOpacity(0.8),
                            AppColor.black.withOpacity(1),
                          ],
                          stops: [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Gap(h: 10),
                          TextSemi(
                            str: 'Comfort Dinner',
                            color: AppColor.white,
                            size: 20,
                          ),
                          Gap(h: 2),
                          TextRegular(
                            str: '(Only Dinner) Light yet satisfying evening meals',
                            color: AppColor.white,
                            size: 13,
                          ),
                          Gap(h: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                DrawableConstant.ic_star,
                                color: AppColor.color_F4C102,
                                width: 16,
                                height: 16,
                              ),
                              Gap(w: 10),
                              TextSemi(str: '4.7', color: AppColor.white, size: 16),
                            ],
                          ),
                          Gap(h: 6),
                          TextSemi(
                            str: '4 Roti | Dal | Salad | Sweets',
                            color: AppColor.white,
                            size: 15,
                          ),
                          Gap(h: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FillButtonWidget(
                                width: 100,
                                height: 38,
                                bgColor: AppColor.red,
                                title: 'Open',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetMenuUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(str: 'Our Menu'.toUpperCase(), color: AppColor.black, size: 20),
    );
  }

  Widget _widgetMenuList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CustomCard(
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.colorBlue, AppColor.white],
            ),
            boxShadow: [
              BoxShadow(color: Color(0x33FF5722), blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _widgetDay(),
                  _widgetWeek('Mon'),
                  _widgetWeek('Tue'),
                  _widgetWeek('Wed'),
                  _widgetWeek('Thu'),
                  _widgetWeek('Fri'),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      _widgetType(),
                      _widgetMeal(
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                      ),
                      _widgetMeal(
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                      ),
                      _widgetMeal(
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                      ),
                      _widgetMeal(
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                      ),
                      _widgetMeal(
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                        'Plan paratha, dal, rice',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetDay() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      width: 80,
      color: AppColor.red,
      child: TextSemi(str: 'Day'.toUpperCase(), color: AppColor.white, size: 15),
    );
  }

  Widget _widgetMeal(String str1, String str2, String str3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          color: AppColor.white,
          alignment: Alignment.center,
          width: 130,
          padding: EdgeInsets.all(2),
          child: TextSemi(align: 2, str: str1, color: AppColor.black, size: 15),
        ),

        Container(
          height: 60,
          padding: EdgeInsets.all(2),
          color: AppColor.white,
          alignment: Alignment.center,
          width: 130,
          child: TextSemi(align: 2, str: str2, color: AppColor.black, size: 15),
        ),

        Container(
          height: 60,
          padding: EdgeInsets.all(2),
          color: AppColor.white,
          alignment: Alignment.center,
          width: 130,
          child: TextSemi(align: 2, str: str3, color: AppColor.black, size: 15),
        ),
      ],
    );
  }

  Widget _widgetType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 40, width: 0.4, color: AppColor.white),
        Container(
          height: 40,
          color: AppColor.color_D25B17,
          alignment: Alignment.center,
          width: 130,
          child: TextSemi(
            str: 'Breakfast'.toUpperCase(),
            color: AppColor.white,
            size: 16,
          ),
        ),
        Container(height: 40, width: 0.4, color: AppColor.white),
        Container(
          height: 40,
          color: AppColor.color_156CD7,
          alignment: Alignment.center,
          width: 130,
          child: TextSemi(str: 'Lunch'.toUpperCase(), color: AppColor.white, size: 16),
        ),
        Container(height: 40, width: 0.4, color: AppColor.white),
        Container(
          height: 40,
          color: AppColor.color_F4C102,
          alignment: Alignment.center,
          width: 130,
          child: TextSemi(str: 'Dinner'.toUpperCase(), color: AppColor.white, size: 16),
        ),
      ],
    );
  }

  Widget _widgetWeek(String w) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        color: AppColor.color_1E6F46,
        width: 80,
        height: 60,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(h: 10),
            Icon(Icons.calendar_month, size: 18, color: AppColor.white),
            Gap(h: 2),
            TextSemi(str: w.toUpperCase(), color: AppColor.white, size: 16),
            Gap(h: 10),
            Container(height: 0.3, color: AppColor.white),
          ],
        ),
      ),
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
