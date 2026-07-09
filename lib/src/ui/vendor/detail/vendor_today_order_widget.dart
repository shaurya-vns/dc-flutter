import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/order/one/OneTimeOrderResponse.dart';
import 'package:flutter_dc/src/ui/dashboard/custom/subscription_order_widget.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_regular.dart';
import '../../common_bloc.dart';
import '../../dashboard/custom/one_time_item_widget.dart';

class VendorTodayOrderWidget extends StatefulWidget {
  final int? userId;

  const VendorTodayOrderWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<VendorTodayOrderWidget> createState() => _VendorTodayOrderWidgetState();
}

class _VendorTodayOrderWidgetState extends State<VendorTodayOrderWidget> {
  late CommonBloc _commonBloc;

  final StreamController<List<OneTimeOrderData>?> _oneTimeTodayOrderStream =
      BehaviorSubject();

  final StreamController<List<SubTodayOrderData>?> _todaySubOrderStream =
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Gap(h: 20), _widgetOneTimeTodayOrder(), _widgetSubTodayOrder()],
      ),
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

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _todaySubOrderStream.stream,
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

  Widget noOrderWidget({
    String title = "No Orders Yet",
    String message =
        "You don't have any orders for today.\nNew orders will appear here automatically.",
    VoidCallback? onRefresh,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(h: 80),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 70,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            TextBold(str: title, size: 22, color: AppColor.black),
            const SizedBox(height: 10),
            TextRegular(str: message, size: 15, align: 2, color: AppColor.color_B0B0B0),
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              child: ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getOrder() {
    _commonBloc.getSubscriptionOrderAPI(
      widget.userId,
      delivery_date: TimeUtils.todayDate,
    );
    _commonBloc.getOneTimeOrderListAPI(widget.userId, delivery_date: TimeUtils.todayDate);
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
            _todaySubOrderStream.sink.add(res.data);
          }

        case ApiType.ONE_TIME_ORDER_LIST:
          {
            var res = OneTimeOrderResponse.fromJson(map);
            _oneTimeTodayOrderStream.sink.add(res.data);
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
