import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/detail/SubscriptionDetailPage.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/subscription/active/SubscriptionData.dart';
import '../../model/response/subscription/active/SubscriptionResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/AppStatus.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../utils/gap.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../../widget/test_medium.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';

class MySubscriptionPage extends StatefulWidget {
  const MySubscriptionPage({super.key});

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<SubscriptionData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getMySubscriptionAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My Subscription',
      isBottom: false,
      onSwipe: () {
        getMySubscriptionAPI();
      },
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<SubscriptionData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Subscription (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetSubscriptionUI(today, data?.length);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _widgetSubscriptionUI(SubscriptionData? sub, int? length) {
    final product = sub?.product;
    final image = AppUtils.getFirstImage(product?.images);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            SubscriptionDetailPage(data: sub),
          );
          getMySubscriptionAPI();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: CacheImage(url: image, w: SCREEN_WIDTH, h: 170),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColor.colorBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextSemi(
                        str: AppStatus.getStatus(sub?.status),
                        color: AppColor.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product Name
                    TextBold(str: product?.name, size: 19, max: 2, color: AppColor.black),

                    Gap(h: 4),

                    /// Category
                    TextRegular(
                      str: AppUtils.formatStatus(product?.category),
                      size: 13,
                      color: AppColor.color_B0B0B0,
                    ),

                    Gap(h: 16),

                    /// Subscription ID + Amount
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextSemi(
                            str: "SUB-${sub?.subNumber}",
                            size: 12,
                            color: AppColor.primaryColor,
                          ),
                        ),

                        Spacer(),

                        Icon(
                          Icons.currency_rupee,
                          size: 18,
                          color: AppColor.primaryColor,
                        ),

                        TextBold(
                          str: AppUtils.formatPrice(sub?.amount),
                          size: 18,
                          color: AppColor.primaryColor,
                        ),
                      ],
                    ),

                    Gap(h: 18),

                    /// Date
                    _infoRow(
                      Icons.calendar_today_outlined,
                      "${TimeUtils.parseDate2(sub?.startDate)}  →  ${TimeUtils.parseDate2(sub?.endDate)}",
                    ),

                    Gap(h: 12),

                    /// Meal
                    _infoRow(
                      Icons.restaurant_menu,
                      AppUtils.getMealSummary(product?.planType, sub?.quantity),
                    ),

                    Gap(h: 12),

                    /// Duration
                    Row(
                      children: [
                        Expanded(
                          child: _infoRow(
                            Icons.timelapse,
                            "${sub?.pricingDetail?.days ?? 0} Days Plan",
                          ),
                        ),

                        Gap(w: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: AppColor.primaryColor,
                              ),
                              Gap(w: 6),
                              TextSemi(
                                str: "${sub?.remainingDays ?? 0} Days Left",
                                size: 13,
                                color: AppColor.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gap(h: 18),

                    Divider(height: 1),

                    Gap(h: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColor.primaryColor,
                        ),

                        Gap(w: 6),

                        TextSemi(
                          str: "View Subscription Details",
                          color: AppColor.primaryColor,
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

  Widget _infoRow(IconData icon, String? text) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColor.primaryColor, size: 18),
        ),

        Gap(w: 12),

        Expanded(child: TextMedium(str: text, size: 13, color: AppColor.black)),
      ],
    );
  }

  void getMySubscriptionAPI() {
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
            _dataStream.sink.add(res.data);
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
