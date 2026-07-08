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
import '../dashboard/custom/subscription_order_widget.dart';
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
                var subscriptionOrder = data?[index];
                return SubscriptionOrderWidget(subscriptionOrder: subscriptionOrder);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
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
