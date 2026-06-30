import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/model/response/subscription/active/SubscriptionData.dart';
import 'package:flutter_dc/src/ui/dashboard/home/today/active_subscription_widget.dart';
import 'package:flutter_dc/src/ui/dashboard/home/today/today_order_widget.dart';
import 'package:flutter_dc/src/ui/detail/subscription_page.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/home/today/TodayOrderData.dart';
import '../../../model/response/product/ProductListResponse.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../common_bloc.dart';
import '../../detail/meal_page.dart';
import '../../shimmer/CustomShimmer.dart';
import '../menu/menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CommonBloc _commonBloc;
  final StreamController<List<TodayOrderData>?> _todayOrderStream = BehaviorSubject();
  final StreamController<List<ProductModel>?> _productsStream = BehaviorSubject();
  final StreamController<List<SubscriptionData>?> _activeSubscriptionStream =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getProductBySubOwnerIdAPI();
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
                    TodayOrderWidget(),
                    Gap(h: 20),
                    ActiveSubscriptionWidget(),
                    Gap(h: 25),
                    _widgetPlanList(),
                    Gap(h: 25),
                    _widgetPerDayMeals(),
                    Gap(h: 10),
                    _widgetPerDayListUI(),
                    Gap(h: 25),
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
          child: TextSemi(str: 'Good Morning, Umesh 👋', size: 17, color: AppColor.black),
        ),
        RoundedContainer(
          width: 35,
          height: 35,
          color: AppColor.color_B0B0B0,
          rounded: 40,
        ),
      ],
    );
  }

  Widget _widgetPlanList() {
    return CommonStreamBuilder<List<ProductModel>?>(
      stream: _productsStream.stream,
      noWidget: CustomShimmer(),
      builder: (context, products) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: TextSemi(
                str: 'Plan (${products?.length})'.toUpperCase(),
                color: AppColor.black,
                size: 17,
              ),
            ),

            SizedBox(
              height: 390,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(products?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var product = products?[index];
                  var image = AppUtils.getFirstImage(product?.images);
                  var price1 = product?.pricingOptions?[0].price;
                  var price2 =
                      product
                          ?.pricingOptions?[AppUtils.getLength(
                                product.pricingOptions?.length,
                              ) -
                              1]
                          .price;

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
                                str: product?.planName,
                                color: AppColor.black,
                                size: 17,
                                max: 1,
                              ),
                            ),
                            Gap(h: 10),
                            CacheImage(url: image, w: SCREEN_WIDTH, h: 140),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(h: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextSemi(
                                        str: product?.name,
                                        color: AppColor.black,
                                        max: 1,
                                        size: 15,
                                      ),
                                      Gap(w: 14),
                                      Container(
                                        width: 0.5,
                                        height: 10,
                                        color: AppColor.black,
                                      ),
                                      Gap(w: 14),
                                      Image.asset(
                                        DrawableConstant.ic_star,
                                        color: AppColor.color_F4C102,
                                        width: 17,
                                        height: 17,
                                      ),
                                      Gap(w: 10),
                                      TextSemi(
                                        str: '4.7',
                                        color: AppColor.black,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  TextSemi(
                                    str: product?.planType?.toTitleCase(),
                                    color: AppColor.color_D25B17,
                                    size: 13,
                                  ),
                                  Gap(h: 3),
                                  TextRegular(
                                    str: product?.include,
                                    color: AppColor.black,
                                    max: 1,
                                    size: 14,
                                  ),
                                  Gap(h: 8),
                                  TextRegular(
                                    str: product?.shortDescription,
                                    color: AppColor.black,
                                    size: 13,
                                    max: 1,
                                  ),
                                  Gap(h: 8),
                                  Row(
                                    children: [
                                      TextSemi(
                                        str: 'Basic Price: ',
                                        color: AppColor.black,
                                        size: 14,
                                      ),
                                      TextBold(
                                        str: AppUtils.formatPrice(price1),
                                        color: AppColor.black,
                                        size: 14,
                                      ),
                                      TextBold(
                                        str: ' - ',
                                        color: AppColor.black,
                                        size: 14,
                                      ),
                                      TextBold(
                                        str: AppUtils.formatPrice(price2),
                                        color: AppColor.black,
                                        size: 14,
                                      ),
                                    ],
                                  ),

                                  Gap(h: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      product?.isSubscribed == true
                                          ? FillButtonWidget(
                                            width: 230,
                                            bgColor: AppColor.red,
                                            title: 'Subscription Now',
                                            onPressed:
                                                product?.isSubscribed == false
                                                    ? null
                                                    : () {
                                                      AppUtils.launchScreen(
                                                        context,
                                                        SubscriptionPage(
                                                          product: product,
                                                        ),
                                                      );
                                                    },
                                          )
                                          : Container(
                                            child: TextSemi(
                                              str: 'Already Subscribed',
                                              size: 16,
                                              color: AppColor.red,
                                            ),
                                            height: 50,
                                            alignment: Alignment.center,
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
            ),
          ],
        );
      },
    );
  }

  Widget _widgetPerDayMeals() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextSemi(
        str: 'Meals Per Day (10+)'.toUpperCase(),
        color: AppColor.black,
        size: 16,
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
                                size: 14,
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
                                  TextSemi(str: '4.7', color: AppColor.black, size: 14),
                                ],
                              ),
                              Gap(h: 6),
                              TextSemi(
                                str: '4 Roti | Dal | Salad | Sweets',
                                color: AppColor.color_0A1B35,
                                size: 14,
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
                        TextBold(str: 'Per day: ', color: AppColor.black, size: 14),
                        TextBold(str: ' ', color: AppColor.black, size: 14),
                        TextBold(
                          str: AppUtils.formatPrice(4000),
                          color: AppColor.black,
                          size: 14,
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
        size: 16,
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
                            size: 15,
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
                              TextSemi(str: '4.7', color: AppColor.white, size: 14),
                            ],
                          ),
                          Gap(h: 6),
                          TextSemi(
                            str: '4 Roti | Dal | Salad | Sweets',
                            color: AppColor.white,
                            size: 14,
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

  void getProductBySubOwnerIdAPI() {
    print('sssssss getProductBySubOwnerIdAPI  ');
    _commonBloc.getProductBySubOwnerIdAPI();
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {
        case ApiType.PRODUCT_BY_SUB_OWNER:
          {
            var res = ProductListResponse.fromJson(map);
            print('sssssss data ${res.data}');
            _productsStream.sink.add(res.data);
          }
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
