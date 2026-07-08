import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/common_response.dart';
import '../../model/response/order/sub/SubTodayOrderData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/AppStatus.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../utils/gap.dart';
import '../../widget/fill_button_widget.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';

class SubscriptionOrderDetailPage extends StatefulWidget {
  final SubTodayOrderData? data;

  const SubscriptionOrderDetailPage({super.key, required this.data});

  @override
  State<SubscriptionOrderDetailPage> createState() => _SubscriptionOrderDetailPageState();
}

class _SubscriptionOrderDetailPageState extends State<SubscriptionOrderDetailPage> {
  late CommonBloc _commonBloc;
  SubTodayOrderData? data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    var product = widget.data?.subscription?.product;
    var selectedPrice = AppUtils.getDouble(
      widget.data?.subscription?.pricingDetail?.price,
    );
    var selectedDay = AppUtils.getInt(widget.data?.subscription?.pricingDetail?.days);
    var pricePerDay = selectedPrice / selectedDay;

    return BaseWidget(
      progressLoaderStream: _commonBloc.progressLoaderStream,
      child: ScaffoldWidget(
        title: 'Subscription Order Detail',
        isBottom: false,
        bottom: _widgetBottom(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _widgetImage(widget.data),
              Gap(h: 15),

              /// DELIVERY
              _card("User Information", [
                _row("Name", data?.subscription?.user?.name),
                _row("Phone Number", data?.subscription?.user?.phoneNumber),
              ]),

              /// DELIVERY
              _card("Delivery", [
                _row("Delivery Date", TimeUtils.parseDate2(widget.data?.deliveryDate)),
                _row("Meal", AppUtils.formatStatus(widget.data?.mealType)),
                _row("Quantity", "${widget.data?.quantity} Thalis"),
              ]),

              /// SUBSCRIPTION
              _card("Subscription Information", [
                _row("Subscription Number", widget.data?.subscription?.subNumber),
                _row("Plan", AppUtils.formatStatus(product?.planType)),
                _row("Price Per Meal", '${AppUtils.formatPrice(pricePerDay)}'),
                _row(
                  "Created On",
                  TimeUtils.parseDate(widget.data?.subscription?.startDate),
                ),
              ]),

              /// VENDOR
              _card("Vendor Details", [_row("Vendor", product?.subOwner?.name)]),
              _card("Delivery Address", [
                _row(widget.data?.subscription?.address?.fullAddress, ''),
                _row('Phone Number', widget.data?.subscription?.address?.phoneNumber),
              ]),

              /// PRICING
              _card("Payment ( On Subscription )", [
                _row(
                  "Price",
                  AppUtils.formatPrice(widget.data?.subscription?.originalPrice),
                ),
                _row("Quantity", '${widget.data?.subscription?.quantity}'),
                _row(
                  "Discount",
                  AppUtils.formatPrice(widget.data?.subscription?.discountAmount),
                ),
                const Divider(),
                _row(
                  "Payable Amount",
                  AppUtils.formatPrice(widget.data?.subscription?.amount),
                  valueStyle: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ]),

              /// TODAY'S MENU
              _card("Today's Meal", [
                Row(children: [TextRegular(str: product?.description, size: 15)]),
              ]),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetImage(SubTodayOrderData? data) {
    var product = data?.subscription?.product;
    var image = AppUtils.getFirstImage(product?.images);
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CacheImage(url: image, w: SCREEN_WIDTH),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(.7), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemi(
                  str: AppUtils.formatStatus(product?.category),
                  color: AppColor.white,
                  size: 20,
                ),
                TextRegular(str: product?.name, color: AppColor.white, size: 15),
                Gap(h: 15),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextRegular(
                        str: AppStatus.getStatus(data?.status),
                        color: AppColor.white,
                        size: 14,
                      ),
                    ),
                    Gap(w: 20),
                    const Icon(Icons.breakfast_dining, color: Colors.white),
                    const SizedBox(width: 4),
                    TextRegular(
                      str: AppUtils.formatStatus(product?.planType),
                      color: AppColor.white,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: RoundedContainer(
        rounded: 10,
        color: AppColor.white,
        padding: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TextSemi(str: title, size: 17), Gap(h: 3), ...children],
        ),
      ),
    );
  }

  Widget _row(String? title, String? value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextRegular(max: 10, str: title, color: AppColor.black, size: 15),
          ),
          TextSemi(str: value, align: 1, max: 10, color: AppColor.black, size: 14),
        ],
      ),
    );
  }

  Widget _widgetBottom() {
    var isSubOwnerUser = USER_DATA?.userType == UserType.SUB_OWNER;
    print('USER_DATA?.userType ${USER_DATA?.userType}');
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child:
          isSubOwnerUser
              ? Row(
                children: [
                  Expanded(
                    child: FillButtonWidget(
                      bgColor: AppColor.black,
                      title: 'Cancel',
                      onPressed: () {
                        updateStatus(OrderStatus.CANCELLED);
                      },
                    ),
                  ),
                  Gap(w: 10),
                  Expanded(
                    child: FillButtonWidget(
                      title: 'Completed',
                      onPressed: () {
                        updateStatus(OrderStatus.DELIVERED);
                      },
                    ),
                  ),
                ],
              )
              : FillButtonWidget(
                bgColor: AppColor.black,
                title: 'Cancel',
                onPressed: () {},
              ),
    );
  }

  void updateStatus(int? status) {
    var orderId = widget.data?.id;
    _commonBloc.updateSubOrderAPI(orderId, status);
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
        case ApiType.UPDATE_SUB_ORDER:
          {
            var res = CommonResponse.fromJson(map);
            AppUtils.showToast(res.message);
            Navigator.pop(context);
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
