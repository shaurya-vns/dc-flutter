import 'dart:async';

import 'package:flutter/material.dart';
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
import '../../../detail/SubscriptionDetailPage.dart';
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
      shimmer: CustomShimmer(),
      builder: (context, active) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(h: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'ACTIVE SUBSCRIPTION (${active?.length})',
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 5),
            SizedBox(
              height: 200,
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
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetActiveSubscriptionItem(SubscriptionData? data, int? length) {
    var gap = length == 1 ? 20 : 80;
    var product = data?.product;
    var image = AppUtils.getFirstImage(data?.product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, SubscriptionDetailPage(data: data));
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
                      TextBold(
                        str: AppUtils.formatStatus(product?.category),
                        size: 19,
                        color: AppColor.white,
                      ),
                      TextRegular(
                        str: AppUtils.formatStatus(product?.planType),
                        size: 12,
                        color: AppColor.white,
                      ),
                      Gap(h: 6),
                      TextSemi(
                        str:
                            '${product?.name} | ${AppUtils.formatPrice(AppUtils.getDouble2(data?.amount))} | ${data?.pricingDetail?.days} days',
                        size: 15,
                        color: AppColor.white,
                      ),

                      Gap(h: 6),
                      Row(
                        children: [
                          TextMedium(
                            str: AppUtils.getMealSummary(
                              data?.product?.planType,
                              data?.quantity,
                            ),
                            size: 14,
                            color: AppColor.white,
                          ),

                          TextMedium(
                            str: ' for ${data?.quantity} person',
                            size: 14,
                            color: AppColor.white,
                          ),
                        ],
                      ),
                      Gap(h: 6),
                      Row(
                        children: [
                          TextMedium(
                            str: TimeUtils.parseDate2(data?.startDate),
                            size: 15,
                            color: AppColor.white,
                          ),
                          TextSemi(str: ' - ', size: 15, color: AppColor.white),
                          TextSemi(
                            str: TimeUtils.parseDate(data?.endDate),
                            size: 15,
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
