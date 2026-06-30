import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/subscription/active/SubscriptionData.dart';
import '../../../../model/response/subscription/active/SubscriptionResponse.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/cache_image.dart';
import '../../../../utils/gap.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../../widget/custome_card.dart';
import '../../../common_bloc.dart';
import '../../../shimmer/CustomShimmer.dart';

class ActiveSubscriptionWidget extends StatefulWidget {
  const ActiveSubscriptionWidget({Key? key}) : super(key: key);

  @override
  State<ActiveSubscriptionWidget> createState() => _ActiveSubscriptionWidgetState();
}

class _ActiveSubscriptionWidgetState extends State<ActiveSubscriptionWidget> {
  late CommonBloc _commonBloc;
  final StreamController<List<SubscriptionData>?> _activeStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getMySubscription();
  }

  @override
  Widget build(BuildContext context) {
    return _widgetActiveSubscription();
  }

  Widget _widgetActiveSubscription() {
    return CommonStreamBuilder<List<SubscriptionData>?>(
      stream: _activeStream.stream,
      noWidget: CustomShimmer(),
      builder: (context, active) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'ACTIVE SUBSCRIPTION (${active?.length})',
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 240,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(active?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var sub = active?[index];
                  return _widgetActiveSubscriptionItem(sub, active?.length);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _widgetActiveSubscriptionItem(SubscriptionData? data, int? length) {
    var gap = length == 1 ? 20 : 40;
    var product = data?.product;
    var image = AppUtils.getFirstImage(data?.product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: SizedBox(
        width: SCREEN_WIDTH - gap,
        child: CustomCard(
          elevation: 10,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              CacheImage(url: image, w: SCREEN_WIDTH, h: 240),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.trans,
                      AppColor.colorBlue.withOpacity(0.8),
                      AppColor.colorBlue.withOpacity(1),
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
                    TextBold(str: product?.planName, size: 19, color: AppColor.white),
                    TextRegular(
                      str: product?.shortDescription,
                      size: 13,
                      color: AppColor.white,
                    ),
                    Gap(h: 10),
                    TextSemi(
                      str:
                          '${product?.name} | ${AppUtils.formatPrice(data?.pricingDetail?.price)} | ${data?.pricingDetail?.days} days',
                      size: 15,
                      color: AppColor.white,
                    ),

                    Gap(h: 4),
                    TextMedium(
                      str: '${product?.planType?.toTitleCase()} | 1 Meal Everyday',
                      size: 14,
                      color: AppColor.white,
                    ),
                    Gap(h: 4),
                    Row(
                      children: [
                        TextSemi(
                          str: 'Subscription Time:  ',
                          size: 15,
                          color: AppColor.white,
                        ),
                        TextMedium(
                          str: TimeUtils.parseDate2(data?.startDate),
                          size: 15,
                          color: AppColor.black,
                        ),

                        TextSemi(str: ' - ', size: 15, color: AppColor.black),

                        TextSemi(
                          str: TimeUtils.parseDate(data?.endDate),
                          size: 15,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                    Gap(h: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextRegular(
                          str: product?.include,
                          size: 14,
                          color: AppColor.white,
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

  void getMySubscription() {
    _commonBloc.getMySubscriptionAPI();
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
        case ApiType.SUBSCRIPTION_ME:
          {
            var res = SubscriptionResponse.fromJson(map);
            _activeStream.sink.add(res.data);
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
