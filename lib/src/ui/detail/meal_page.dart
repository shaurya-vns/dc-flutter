import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/ui/common_bloc.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/base_error.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../widget/SlideToPayButton.dart';
import '../../widget/all_field_widget.dart';
import '../../widget/scaffold_widget.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> with BaseMixin {
  late CommonBloc _loginBloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    totalAmount = 3500;
    currentAmount = totalAmount;
    controller.text = '1';
    super.initState();
    _loginBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      isBottom: false,
      bottom: _widgetBottomUI(),
      back: widgetBackUI(context, 'Comfort Dinner Plan'),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_widgetBannerUI(), _widgetUI(), _widgetPriceUI(), Gap(h: 100)],
        ),
      ),
    );
  }

  Widget _widgetBannerUI() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  DrawableConstant.ic_test,
                  width: SCREEN_WIDTH,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 210,
            viewportFraction: 0.9,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: true,
          ),
        ),
      ),
    );
  }

  Widget _widgetUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(
            str: 'Comfort Dinner Plan (Only Dinner)',
            size: 20,
            color: AppColor.black,
          ),
          Gap(h: 2),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                TextMedium(str: '* Dal  ', size: 15, color: AppColor.black),
                TextMedium(str: '* Curry', size: 15, color: AppColor.black),
                TextMedium(str: '* Rice', size: 15, color: AppColor.black),
                TextMedium(str: '* 4 Roti', size: 15, color: AppColor.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int index = 1;
  int quantity = 1;

  Widget _widgetPriceUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: 'Best offer', size: 18, color: AppColor.black),
          Gap(h: 10),
          FixButtonWidget(
            height: 50,
            color: AppColor.white,
            borderColor: AppColor.color_156CD7,
            onPressed: () {
              index = 1;
              currentAmount = 3500;
              totalAmount = currentAmount * quantity;
              setState(() {});
            },
            child: Row(
              children: [
                Gap(w: 15),
                Icon(
                  size: 22,
                  index == 1
                      ? Icons.radio_button_checked_outlined
                      : Icons.radio_button_off,
                  color: AppColor.color_156CD7,
                ),
                Gap(w: 6),
                TextSemi(
                  str: '20 days ${AppUtils.formatPrice(3500)} / person',
                  size: 18,
                  color: AppColor.color_156CD7,
                ),
              ],
            ),
          ),
          Gap(h: 5),
          FixButtonWidget(
            height: 50,
            color: AppColor.white,
            borderColor: AppColor.color_156CD7,
            onPressed: () {
              index = 2;
              currentAmount = 4000;
              totalAmount = currentAmount * quantity;
              setState(() {});
            },
            child: Row(
              children: [
                Gap(w: 15),
                Icon(
                  size: 22,
                  index == 2
                      ? Icons.radio_button_checked_outlined
                      : Icons.radio_button_off,
                  color: AppColor.color_156CD7,
                ),
                Gap(w: 6),
                TextSemi(
                  str: '25 days ${AppUtils.formatPrice(4000)} / person',
                  size: 18,
                  color: AppColor.color_156CD7,
                ),
              ],
            ),
          ),
          Gap(h: 5),

          FixButtonWidget(
            height: 50,
            color: AppColor.white,
            borderColor: AppColor.color_156CD7,
            onPressed: () {
              index = 3;
              currentAmount = 5000;
              totalAmount = currentAmount * quantity;
              setState(() {});
            },
            child: Row(
              children: [
                Gap(w: 15),
                Icon(
                  size: 22,
                  index == 3
                      ? Icons.radio_button_checked_outlined
                      : Icons.radio_button_off,
                  color: AppColor.color_156CD7,
                ),
                Gap(w: 6),
                TextSemi(
                  str: '30 days ${AppUtils.formatPrice(5000)} / person',
                  size: 18,
                  color: AppColor.color_156CD7,
                ),
              ],
            ),
          ),
          Gap(h: 15),
          Row(
            children: [
              Expanded(
                child: TextSemi(str: 'Add Person', size: 18, color: AppColor.black),
              ),
              FixButtonWidget(
                onPressed: () {
                  if (quantity != 1) {
                    quantity--;
                  }
                  totalAmount = currentAmount * quantity;
                  controller.text = '$quantity';
                  setState(() {});
                },
                child: TextSemi(str: '-', size: 30, color: AppColor.black),
              ),
              Gap(w: 20),
              Container(
                alignment: Alignment.center,
                width: 80,
                child: AllFieldWidget(
                  controller: controller,
                  field: 'Quantity',
                  preNode: null,
                  nextNode: null,
                  max: 3,
                  onTypeChange: (String value) {
                    quantity = AppUtils.getInt4(value);
                    totalAmount = currentAmount * quantity;
                    setState(() {});
                  },
                ),
              ),
              Gap(w: 20),
              FixButtonWidget(
                onPressed: () {
                  print('quantity $quantity');
                  print('currentAmount $currentAmount');
                  print('totalAmount $totalAmount');
                  quantity++;
                  controller.text = '$quantity';
                  totalAmount = currentAmount * quantity;
                  setState(() {});
                },
                child: TextSemi(str: '+', size: 30, color: AppColor.black),
              ),
            ],
          ),

          Gap(h: 20),
          Container(
            width: SCREEN_WIDTH,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.color_0D47A1, AppColor.black],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33FF5722),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  const TextSpan(text: 'You have subscribed plan for '),
                  TextSpan(
                    text: ' $quantity person.',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const TextSpan(text: '\nTotal payable amount '),
                  TextSpan(
                    text: ' ${AppUtils.formatPrice(totalAmount)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  double totalAmount = 0;
  double currentAmount = 0;

  Widget _widgetBottomUI() {
    String grandTotal = AppUtils.formatPrice(totalAmount);
    return grandTotal == 0
        ? SizedBox()
        : Container(
          width: SCREEN_WIDTH,
          color: AppColor.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: SlideToPayButton(amount: grandTotal, onSuccess: () {}),
          ),
        );
  }

  Widget _widgetBottomUI1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FillButtonWidget(
            bgColor: AppColor.red,
            title: 'Subscription',
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.onDispose();
  }

  void setObservables() {
    //success listener
    _loginBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.LOGIN:
          {}
      }
    });
    //error listener
    _loginBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
