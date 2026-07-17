import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../model/response/order/one/OneTimeOrderResponse.dart';
import '../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../utils/widgetUtils.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_bold.dart';
import '../../common_bloc.dart';
import '../../dashboard/custom/one_time_item_widget.dart';
import '../../dashboard/custom/subscription_order_widget.dart';
import '../../shimmer/CustomShimmer.dart';

class VendorUserOrderWidget extends StatefulWidget {
  final int? userId;

  const VendorUserOrderWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<VendorUserOrderWidget> createState() => _VendorUserOrderWidgetState();
}

class _VendorUserOrderWidgetState extends State<VendorUserOrderWidget> {
  late CommonBloc _commonBloc;

  final StreamController<List<OneTimeOrderData>?> _oneTimeTodayOrderStream =
      BehaviorSubject();

  final StreamController<List<SubTodayOrderData>?> _subUserOrderStream =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getOrder();
      },
      child: SingleChildScrollView(
        child: Column(children: [_widgetOneTimeOrder(), _widgetSubOrder(), Gap(h: 100)]),
      ),
    );
  }

  Widget _widgetOneTimeOrder() {
    return CommonStreamBuilder<List<OneTimeOrderData>?>(
      stream: _oneTimeTodayOrderStream.stream,
      shimmer: CustomShimmer(),
      nothing: WidgetUtils.noOrderWidget(
        title: "No Orders Yet",
        message:
            "You don't have any orders for today.\nNew orders will appear here automatically.",
        onRefresh: () {
          getOrder();
        },
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(h: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'One Time Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var oneTimeOrder = data?[index];
                return OneTimeOrderWidget(oneTimeOrder: oneTimeOrder);
              },
            ),
            Gap(h: 20),
          ],
        );
      },
    );
  }

  Widget _widgetSubOrder() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _subUserOrderStream.stream,
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var subscriptionOrder = data?[index];
                return SubscriptionOrderWidget(subscriptionOrder: subscriptionOrder);
              },
            ),
            Gap(h: 200),
          ],
        );
      },
    );
  }

  void getOrder() {
    _commonBloc.getOneTimeOrderListAPI(widget.userId);
    _commonBloc.getSubscriptionOrderAPI(widget.userId);
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
        case ApiType.ONE_TIME_ORDER_LIST:
          {
            var res = OneTimeOrderResponse.fromJson(map);
            _oneTimeTodayOrderStream.sink.add(res.data);
          }
        case ApiType.SUBSCRIPTION_ORDER_LIST:
          {
            var res = SubTodayOrderResponse.fromJson(map);
            _subUserOrderStream.sink.add(res.data);
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
