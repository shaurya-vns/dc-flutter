import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/subscription/active/SubscriptionData.dart';
import '../../../../model/response/subscription/active/SubscriptionResponse.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/AppStatus.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/cache_image.dart';
import '../../../../utils/gap.dart';
import '../../../../utils/widgetUtils.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../common_bloc.dart';
import '../../../detail/SubscriptionDetailPage.dart';
import '../../../shimmer/CustomShimmer.dart';

class ActiveSubscriptionWidget extends StatefulWidget {
  final int? userId;

  const ActiveSubscriptionWidget({Key? key, required this.userId}) : super(key: key);

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
    getSubscriptionAPI();
  }

  @override
  Widget build(BuildContext context) {
    return _widgetActiveSubscription();
  }

  Widget _widgetActiveSubscription() {
    return RefreshIndicator(
      onRefresh: () async {
        getSubscriptionAPI();
      },
      child: SingleChildScrollView(
        child: CommonStreamBuilder<List<SubscriptionData>?>(
          stream: _activeStream.stream,
          shimmer: CustomShimmer(),
          nothing: WidgetUtils.noOrderWidget(
            onRefresh: () {
              getSubscriptionAPI();
            },
          ),
          builder: (context, active) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(h: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextBold(
                    str: 'ACTIVE SUBSCRIPTION (${active?.length})',
                    size: 14,
                    color: AppColor.black,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AppUtils.getLength(active?.length),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var sub = active?[index];
                    return _widgetActiveSubscriptionItem(sub, active?.length);
                  },
                ),
                Gap(h: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _widgetActiveSubscriptionItem(SubscriptionData? data, int? length) {
    final product = data?.product;
    final image = AppUtils.getFirstImage(product?.images);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          AppUtils.launchScreen(context, SubscriptionDetailPage(data: data));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                /// TOP
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CacheImage(url: image, w: 75, h: 75),
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextSemi(str: product?.name, size: 16, max: 2),
                                    TextRegular(
                                      str: AppUtils.formatStatus(product?.category),
                                      color: Colors.grey,
                                      size: 11,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppStatus.statusWidget(data?.paymentStatus),
                                  Gap(h: 3),
                                  TextSemi(
                                    str: "${data?.remainingDays ?? 0} Days Left",
                                    size: 10,
                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _chip(
                        Icons.restaurant,
                        AppUtils.formatStatus(product?.planType),
                        Colors.orange,
                      ),
                      _chip(Icons.people, "${data?.quantity} Person", Colors.blue),
                      _chip(
                        Icons.calendar_month,
                        "${data?.pricingDetail?.days} Days",
                        Colors.green,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextSemi(
                        str: AppUtils.formatPrice(data?.amount),
                        size: 18,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),

                if (data?.paymentStatus == AppStatus.paymentReceived) ...[
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 18, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextRegular(
                          str:
                              "${TimeUtils.parseDate2(data?.startDate)}  -  ${TimeUtils.parseDate(data?.endDate)}",
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextSemi(str: 'Payment is Pending', size: 16, color: AppColor.black),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// COMMON CHIP
  Widget _chip(IconData icon, String? text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          TextRegular(str: text, color: color, size: 13),
        ],
      ),
    );
  }

  void getSubscriptionAPI() {
    _commonBloc.getSubscriptionAPI(widget.userId);
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
        case ApiType.SUBSCRIPTION_LIST_BY_USER:
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
