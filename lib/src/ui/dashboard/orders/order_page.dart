import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../mixin/BaseMixin.dart';
import '../../../model/base_error.dart';
import '../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../model/response/order/one/OneTimeOrderResponse.dart';
import '../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../utils/time_utils.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_bold.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';
import '../custom/one_time_item_widget.dart';
import '../custom/subscription_order_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with BaseMixin {
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
    return Container(
      color: AppColor.color_bg,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchWidget(),
              Gap(h: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(h: 10),
                  _widgetOneTimeTodayOrder(),
                  _widgetSubTodayOrder(),
                ],
              ),
              Gap(h: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetOneTimeTodayOrder() {
    return CommonStreamBuilder<List<OneTimeOrderData>?>(
      stream: _oneTimeTodayOrderStream.stream,
      shimmer: CustomShimmer(),
      nothing: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
        child: RoundedContainer(
          padding: 15,
          alignment: Alignment.center,
          child: Column(
            children: [
              TextSemi(
                size: 15,
                str: 'No One Time Orders Yet',
                color: AppColor.colorBlue,
              ),
              Gap(h: 10),
              TextRegular(
                align: 2,
                size: 13,
                color: AppColor.colorBlue,
                str:
                    'You don\'t have any orders for today.\nNew orders will appear here automatically.',
              ),
            ],
          ),
        ),
      ),
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
      nothing: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
        child: RoundedContainer(
          padding: 15,
          alignment: Alignment.center,
          child: Column(
            children: [
              TextSemi(
                size: 15,
                str: 'No Subscription Orders Yet',
                color: AppColor.colorBlue,
              ),
              Gap(h: 10),
              TextRegular(
                align: 2,
                size: 13,
                color: AppColor.colorBlue,
                str:
                    'You don\'t have any orders for today.\nNew orders will appear here automatically.',
              ),
            ],
          ),
        ),
      ),
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
            Gap(h: 20),
          ],
        );
      },
    );
  }

  void getOrder() {
    _commonBloc.getSubscriptionOrderAPI(
      USER_DATA?.id,
      delivery_date: TimeUtils.todayDate,
    );
    _commonBloc.getOneTimeOrderListAPI(USER_DATA?.id, delivery_date: TimeUtils.todayDate);
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
