import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/custome_card.dart';
import '../../../widget/custome_line.dart';
import '../../../widget/fill_button_widget.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_bold.dart';
import '../../../widget/test_medium.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
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
                    Gap(h: 10),
                    _widgetActiveSubscription(),
                    Gap(h: 30),
                    _widgetSubscriptionMeals(),
                    Gap(h: 10),
                    _widgetListSubscriptionMealsUI(),
                    Gap(h: 200),
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
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 4,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomCard(
            elevation: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  DrawableConstant.ic_test,
                  fit: BoxFit.cover,
                  width: SCREEN_WIDTH,
                  height: 200,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 1, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(h: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextSemi(
                              str: 'Comfort Dinner',
                              color: AppColor.black,
                              size: 20,
                            ),
                          ),
                          Gap(w: 15),
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
                              TextSemi(
                                str: '4.5',
                                color: AppColor.color_0A1B35,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(h: 6),
                      TextSemi(
                        align: 2,
                        str: '4 Roti Dal Salad Sweets',
                        color: AppColor.color_0A1B35,
                        size: 18,
                      ),
                      Gap(h: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      Gap(h: 6),
                      Row(
                        children: [
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
                      Gap(h: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FillButtonWidget(
                            width: 230,
                            bgColor: AppColor.red,
                            title: 'Subscribe Meal',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Gap(h: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _widgetHeader() {
    return Row(
      children: [
        Expanded(
          child: TextSemi(str: 'Subscription 👋', size: 20, color: AppColor.black),
        ),
        RoundedContainer(w: 35, h: 35, color: AppColor.color_B0B0B0, rounded: 40),
      ],
    );
  }

  Widget _widgetActiveSubscription() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBold(str: 'ACTIVE SUBSCRIPTION ', size: 17, color: AppColor.black),
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
