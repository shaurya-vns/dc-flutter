import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/order/sub/SubTodayOrderData.dart';
import '../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../utils/gap.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/custome_card.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../../widget/test_medium.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';
import 'SubscriptionOrderDetailPage.dart';

class MySubOrderPage extends StatefulWidget {
  const MySubOrderPage({super.key});

  @override
  State<MySubOrderPage> createState() => _MySubOrderPageState();
}

class _MySubOrderPageState extends State<MySubOrderPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<SubTodayOrderData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getSubscriptionOrderAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My Subscription Orders',
      isBottom: false,
      onSwipe: () {
        getSubscriptionOrderAPI();
      },
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Orders (${data?.length})'.toUpperCase(),
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
                return _widgetTodayItemUI(today, data?.length);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _widgetTodayItemUI(SubTodayOrderData? sub, int? length) {
    var product = sub?.subscription?.product;
    var image = AppUtils.getFirstImage(product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            SubscriptionOrderDetailPage(data: sub),
          );
          getSubscriptionOrderAPI();
        },
        child: CustomCard(
          rounded: 5,
          color: AppColor.white,
          child: Row(
            children: [
              CacheImage(url: image, w: 90, h: 90),
              Gap(w: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextMedium(
                          str: 'Order Id: ${sub?.id}',
                          max: 1,
                          color: AppColor.black,
                          size: 14,
                        ),
                        Expanded(
                          child: TextMedium(
                            str: AppUtils.getOrderStatus(sub?.status),
                            max: 1,
                            align: 1,
                            color: AppColor.colorBlue,
                            size: 12,
                          ),
                        ),
                        Gap(w: 10),
                      ],
                    ),
                    TextSemi(
                      str: AppUtils.formatStatus(product?.category),
                      max: 1,
                      color: AppColor.black,
                      size: 14,
                    ),
                    TextRegular(
                      str: product?.name,
                      max: 1,
                      color: AppColor.black,
                      size: 12,
                    ),
                    Gap(h: 4),
                    TextRegular(
                      str: 'Delivery Date: ${TimeUtils.parseDate2(sub?.deliveryDate)}',
                      max: 1,
                      color: AppColor.black,
                      size: 13,
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

  void getSubscriptionOrderAPI() {
    _commonBloc.getSubscriptionOrderAPI(USER_DATA?.id);
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
        case ApiType.SUBSCRIPTION_ORDER_LIST:
          {
            var res = SubTodayOrderResponse.fromJson(map);
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
