import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/model/response/home/today/TodayOrderResponse.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/home/today/TodayOrderData.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/gap.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../common_bloc.dart';

class TodayOrderWidget extends StatefulWidget {
  const TodayOrderWidget({Key? key}) : super(key: key);

  @override
  State<TodayOrderWidget> createState() => _TodayOrderWidgetState();
}

class _TodayOrderWidgetState extends State<TodayOrderWidget> {
  late CommonBloc _commonBloc;
  final StreamController<List<TodayOrderData>?> _todayOrderStream = BehaviorSubject();

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
    return _widgetTodayPlan();
  }

  Widget _widgetTodayPlan() {
    return CommonStreamBuilder<List<TodayOrderData>?>(
      stream: _todayOrderStream.stream,
      noWidget: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Today\'s Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 220,
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
          ],
        );
      },
    );
  }

  Widget _widgetTodayItemUI(TodayOrderData? today, int? length) {
    var gap = length == 1 ? 20 : 40;
    var product = today?.product;
    var image = AppUtils.getFirstImage(today?.product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: SizedBox(
        width: SCREEN_WIDTH - gap,
        child: CustomCard(
          elevation: 1,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              CacheImage(url: image, w: SCREEN_WIDTH, h: 220),
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
                    TextSemi(str: product?.planName, color: AppColor.white, size: 17),
                    Gap(h: 4),
                    TextMedium(str: product?.name, color: AppColor.white, size: 14),
                    Row(
                      children: [
                        TextMedium(
                          str: product?.planType?.toTitleCase(),
                          color: AppColor.color_EA645F,
                          size: 13,
                        ),
                        Gap(w: 10),
                        TextSemi(str: '|', color: AppColor.white, size: 12),
                        Gap(w: 10),
                        TextRegular(
                          str: AppUtils.getOrderStatus(today?.status),
                          color: AppColor.color_EA645F,
                          size: 13,
                        ),
                        Gap(w: 10),
                        Image.asset(
                          DrawableConstant.ic_star,
                          color: AppColor.color_EA645F,
                          width: 14,
                          height: 14,
                        ),
                        Gap(w: 4),
                        TextSemi(str: '4.7', color: AppColor.color_EA645F, size: 14),
                      ],
                    ),

                    Gap(h: 6),
                    TextSemi(str: product?.include, color: AppColor.white, size: 12),
                    Gap(h: 6),
                    Row(
                      children: [
                        TextSemi(str: 'Delivery: ', color: AppColor.white, size: 14),
                        TextSemi(
                          str: today?.deliveryDate,
                          color: AppColor.white,
                          size: 14,
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
  }

  void getMyTodayOrder() {
    _commonBloc.getMyTodayOrderAPI();
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
        case ApiType.TODAY_ORDER_LIST:
          {
            var res = TodayOrderResponse.fromJson(map);
            _todayOrderStream.sink.add(res.data);
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
