import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/order/one/OneTimeOrderResponse.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/gap.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../common_bloc.dart';
import '../../../detail/OneTimeOrderDetailPage.dart';
import '../../../detail/SubscriptionOrderDetailPage.dart';

class TodayOrderWidget extends StatefulWidget {
  const TodayOrderWidget({Key? key}) : super(key: key);

  @override
  State<TodayOrderWidget> createState() => _TodayOrderWidgetState();
}

class _TodayOrderWidgetState extends State<TodayOrderWidget> {
  late CommonBloc _commonBloc;
  final StreamController<List<SubTodayOrderData>?> _todayOrderStream = BehaviorSubject();
  final StreamController<List<SubTodayOrderData>?> _nextOrderStream = BehaviorSubject();
  final StreamController<List<OneTimeOrderData>?> _oneTimeTodayOrderStream =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getMyTodayOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(h: 10),
        _widgetOneTimeTodayOrder(),
        _widgetSubTodayOrder(),
        _widgetNextDay(),
      ],
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _todayOrderStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Subscription Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var today = data?[index];
                  return _widgetTodayItemUI(today, data?.length);
                },
              ),
            ),
            Gap(h: 20),
          ],
        );
      },
    );
  }

  Widget _widgetOneTimeTodayOrder() {
    return CommonStreamBuilder<List<OneTimeOrderData>?>(
      stream: _oneTimeTodayOrderStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'One Time Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 160,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var today = data?[index];
                  return _widgetOneTimeTodayItemUI(today, data?.length);
                },
              ),
            ),
            Gap(h: 20),
          ],
        );
      },
    );
  }

  Widget _widgetNextDay() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _nextOrderStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Subscription Next Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var today = data?[index];
                  return _widgetTodayItemUI(today, data?.length);
                },
              ),
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetTodayItemUI(SubTodayOrderData? today, int? length) {
    var gap = length == 1 ? 20 : 40;
    var product = today?.product;
    var image = AppUtils.getFirstImage(today?.product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, SubscriptionOrderDetailPage(data: today));
        },
        child: SizedBox(
          width: SCREEN_WIDTH - gap,
          child: CustomCard(
            elevation: 1,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CacheImage(url: image, w: SCREEN_WIDTH, h: 200),
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
                      TextSemi(
                        str: AppUtils.formatStatus(product?.category),
                        color: AppColor.white,
                        size: 17,
                      ),
                      Gap(h: 20),
                      TextMedium(
                        str: product?.name,
                        max: 1,
                        color: AppColor.white,
                        size: 14,
                      ),
                      Gap(h: 4),
                      Row(
                        children: [
                          TextMedium(
                            str: today?.mealType?.toTitleCase(),
                            color: AppColor.white,
                            size: 13,
                          ),
                          Gap(w: 10),
                          TextSemi(str: '|', color: AppColor.white, size: 12),
                          Gap(w: 6),
                          TextRegular(
                            str: AppUtils.getOrderStatus(today?.status),
                            color: AppColor.white,
                            size: 13,
                          ),

                          Gap(w: 10),
                        ],
                      ),
                      Gap(h: 10),
                      TextRegular(
                        str: AppUtils.getMealSummary(today?.mealType, today?.quantity),
                        size: 13,
                        color: AppColor.white,
                      ),
                      Gap(h: 10),

                      TextSemi(
                        str: TimeUtils.getDisplayTitle(
                          today?.deliveryDate,
                          today?.mealType,
                        ),
                        color: AppColor.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetOneTimeTodayItemUI(OneTimeOrderData? data, int? length) {
    var gap = length == 1 ? 10 : 40;
    var product = data?.product;
    var image = AppUtils.getFirstImage(data?.product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, OneTimeOrderDetailPage(data: data));
        },
        child: SizedBox(
          width: SCREEN_WIDTH - gap,
          child: CustomCard(
            rounded: 15,
            elevation: 1,
            child: Row(
              children: [
                Stack(
                  children: [
                    CacheImage(round: 15, url: image, w: 140, h: 160),
                    Container(
                      width: 140,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColor.trans,
                            AppColor.black.withOpacity(0.3),
                            AppColor.black.withOpacity(1),
                          ],
                          stops: [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedContainer(
                        color: AppColor.color_EA645F.withOpacity(0.3),
                        border: AppColor.trans,
                        height: 22,
                        child: Row(
                          children: [
                            Gap(w: 5),
                            Icon((Icons.star), size: 13, color: AppColor.white),
                            Gap(w: 4),
                            TextSemi(str: '4.5', color: AppColor.white, size: 11),
                            Gap(w: 5),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextMedium(
                              str: data?.mealType?.toTitleCase(),
                              color: AppColor.white,
                              size: 13,
                            ),
                            TextRegular(
                              str: AppUtils.getOrderStatus(data?.status),
                              color: AppColor.white,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 13,
                      bottom: 8,
                      right: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemi(
                          str: AppUtils.formatStatus(product?.category),
                          max: 1,
                          color: AppColor.black,
                          size: 15,
                        ),
                        Gap(h: 20),
                        TextMedium(
                          str: product?.name,
                          max: 1,
                          color: AppColor.black,
                          size: 13,
                        ),

                        Gap(h: 20),
                        TextRegular(
                          str: AppUtils.getMealSummary(data?.mealType, data?.quantity),
                          size: 13,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMyTodayOrder() {
    _commonBloc.getMyTodayOrderAPI();
    _commonBloc.getNextDayOrderListAPI();
    _commonBloc.getOneTimeTodayOrderListAPI();
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
        case ApiType.SUB_TODAY_ORDER_LIST:
          {
            var res = SubTodayOrderResponse.fromJson(map);
            _todayOrderStream.sink.add(res.data);
          }
        case ApiType.SUB_NEXT_DAY_ORDER:
          {
            var res = SubTodayOrderResponse.fromJson(map);
            _nextOrderStream.sink.add(res.data);
          }
        case ApiType.GET_ONE_TIME_TODAY_ORDER_LIST:
          {
            var res = OneTimeOrderResponse.fromJson(map);
            _oneTimeTodayOrderStream.sink.add(res.data);
            print('GET_ONE_TIME_TODAY_ORDER_LIST ${res?.data?.length}');
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
