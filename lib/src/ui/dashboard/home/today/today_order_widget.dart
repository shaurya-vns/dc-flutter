import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/order/one/OneTimeOrderResponse.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/gap.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../common_bloc.dart';
import '../../../detail/OneTimeOrderDetailPage.dart';
import '../../../detail/SubscriptionOrderDetailPage.dart';

class TodayOrderWidget extends StatefulWidget {
  const TodayOrderWidget({Key? key}) : super(key: key);

  @override
  State<TodayOrderWidget> createState() => _TodayOrderWidgetState();
}

class _TodayOrderWidgetState extends State<TodayOrderWidget> {
  late CommonBloc _commonBloc;

  final StreamController<List<OneTimeOrderData>?> _oneTimeTodayOrderStream =
      BehaviorSubject();

  final StreamController<List<SubTodayOrderData>?> _todaySubOrderStream =
      BehaviorSubject();

  // final StreamController<List<SubTodayOrderData>?> _nextOrderStream = BehaviorSubject();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(h: 10),
        _widgetOneTimeTodayOrder(),
        _widgetSubTodayOrder(),
        //  _widgetNextDay(),
      ],
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
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetOneTimeTodayItemUI(today, data?.length);
              },
            ),
            Gap(h: 20),
          ],
        );
      },
    );
  }

  Widget _widgetOneTimeTodayItemUI(OneTimeOrderData? order, int? length) {
    final product = order?.product;
    final image = AppUtils.getFirstImage(product?.images);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          AppUtils.launchScreen(context, OneTimeOrderDetailPage(data: order));
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT COLOR BAR
              Container(
                width: 6,
                height: 170,
                decoration: const BoxDecoration(
                  color: Color(0xffFF6B35),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE + PRODUCT
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CacheImage(url: image, w: 75, h: 75),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextSemi(str: product?.name, size: 17, max: 2),
                                TextRegular(
                                  str: AppUtils.formatStatus(product?.category),
                                  color: AppColor.color_B0B0B0,
                                  size: 13,
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _chip(
                                      Icons.restaurant,
                                      order?.mealType?.toTitleCase(),
                                      Colors.orange,
                                    ),

                                    _chip(
                                      Icons.shopping_bag_outlined,
                                      "Qty ${order?.quantity}",
                                      Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextSemi(
                                str: AppUtils.formatPrice(order?.finalAmount),
                                size: 18,
                                color: AppColor.primaryColor,
                              ),

                              const SizedBox(height: 8),
                              _statusChip(order?.status),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 5),

                      /// ORDER ID
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: TextRegular(str: "Order #${order?.id}", size: 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// DELIVERY DATE
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextRegular(
                              str: TimeUtils.getDisplayTitle(
                                order?.deliveryDate,
                                order?.mealType,
                              ),
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                var today = data?[index];
                return _widgetSubscriptionUI(today);
              },
            ),
            Gap(h: 20),
          ],
        );
      },
    );
  }

  Widget _widgetSubscriptionUI(SubTodayOrderData? order) {
    final product = order?.subscription?.product;
    final image = AppUtils.getFirstImage(product?.images);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          AppUtils.launchScreen(context, SubscriptionOrderDetailPage(data: order));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// Top
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CacheImage(url: image, w: 70, h: 70),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemi(str: product?.name, size: 15, max: 1),
                          TextRegular(
                            size: 13,
                            str: AppUtils.formatStatus(product?.category),
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: [
                              _chip(
                                Icons.restaurant,
                                order?.mealType?.toTitleCase(),
                                Colors.orange,
                              ),

                              _chip(
                                Icons.shopping_bag,
                                "Qty ${order?.quantity}",
                                Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _statusChip(order?.status),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined, size: 18),
                    SizedBox(width: 6),
                    Text("Order #${order?.id}"),
                    Spacer(),
                    TextSemi(
                      str: AppUtils.formatPrice(order?.subscription?.amount),
                      size: 16,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 18),
                    SizedBox(width: 6),
                    Expanded(
                      child: TextRegular(
                        size: 13,
                        str: TimeUtils.getDisplayTitle(
                          order?.deliveryDate,
                          order?.mealType,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String? text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          TextRegular(str: text, color: color, size: 10),
        ],
      ),
    );
  }

  Widget _statusChip(int? status) {
    Color color = Colors.orange;
    String text = AppUtils.getOrderStatus(status);
    if (status == 3) {
      color = Colors.green;
    } else if (status == 4) {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextSemi(str: text, color: color, size: 10),
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

        case ApiType.SUB_NEXT_DAY_ORDER:
          {
            /* var res = SubTodayOrderResponse.fromJson(map);
            _nextOrderStream.sink.add(res.data);*/
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
