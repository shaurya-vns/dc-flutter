import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/review/AddReviewPage.dart';
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
import '../../utils/dialog_utils.dart';
import '../../utils/gap.dart';
import '../../widget/fill_button_widget.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';
import '../raise/RaisedIssueWidget.dart';

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
        support: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.support_agent, color: Colors.red, size: 26),
          ),
        ),
        bottom: _widgetBottom(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _widgetImage(widget.data),
              Gap(h: 15),

              /// DELIVERY
              _card("User Information", [
                _row("Name", data?.subscription?.user?.name),
                InkWell(
                  onTap: () {
                    AppUtils.makePhoneCall(data?.subscription?.user?.phoneNumber);
                  },
                  child: _row(
                    "Phone Number",
                    data?.subscription?.user?.phoneNumber,
                    copy: Icons.call,
                  ),
                ),
              ]),

              /// DELIVERY
              _card("Delivery", [
                _row("Delivery Date", TimeUtils.parseDate2(widget.data?.deliveryDate)),
                _row("Meal", AppUtils.formatStatus(widget.data?.mealType)),
                _row("Quantity", "${widget.data?.quantity} Thalis"),
              ]),

              _widgetReview(data),

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
              _card("Vendor Details", [_row("Vendor", product?.vendor?.name)]),

              _card("Delivery Address", [
                InkWell(
                  onTap: () {
                    AppUtils.openGoogleMap(
                      data?.subscription?.address?.latitude,
                      data?.subscription?.address?.longitude,
                    );
                  },
                  child: _row(
                    data?.subscription?.address?.fullAddress,
                    '',
                    copy: Icons.location_on,
                  ),
                ),
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
                ),
              ]),

              Gap(h: 5),
              RaisedIssueWidget(),

              _card("Meal Description", [
                Row(children: [TextRegular(str: product?.description, size: 15)]),
              ]),

              if (AppUtils.isNotBlank(data?.cancelReason))
                _card("User Cancellation Reason", [
                  Row(children: [TextRegular(str: data?.cancelReason, size: 15)]),
                ]),

              if (AppUtils.isNotBlank(data?.rejectReason))
                _card("Vendor Rejected Reason", [
                  Row(
                    children: [
                      TextRegular(
                        str: data?.rejectReason,
                        size: 15,
                        color: AppColor.black,
                      ),
                    ],
                  ),
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
                colors: [Colors.black.withOpacity(1), Colors.transparent],
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
                    const Icon(Icons.breakfast_dining, color: Colors.white),
                    const SizedBox(width: 4),
                    TextRegular(
                      str: AppUtils.formatStatus(product?.planType),
                      color: AppColor.white,
                      size: 14,
                    ),
                    Gap(w: 20),
                    AppStatus.statusWidget(data?.status),
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

  Widget _row(String? title, String? value, {IconData? copy = null}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextRegular(max: 10, str: title, color: AppColor.black, size: 15),
          ),
          TextSemi(str: value, align: 1, max: 10, color: AppColor.black, size: 14),
          if (copy != null) ...[Gap(w: 5), Icon(copy, size: 19, color: AppColor.red)],
        ],
      ),
    );
  }

  Widget _widgetReview(SubTodayOrderData? data) {
    if (data?.status == AppStatus.delivered)
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppUtils.launchScreen(
              context,
              AddReviewPage(productId: data?.subscription?.product?.id),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.color_B0B0B0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star_rounded, color: Colors.amber, size: 30),
                ),

                Gap(w: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSemi(str: "Rate & Review", size: 18, color: AppColor.black),
                      Gap(h: 4),
                      TextRegular(
                        str: "Share your experience with this meal.",
                        size: 14,
                        color: AppColor.color_B0B0B0,
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      );

    return SizedBox();
  }

  Widget _widgetBottom() {
    var isVendor = USER_DATA?.userType == UserType.VENDOR;
    return data?.status == AppStatus.cancelled ||
            data?.status == AppStatus.rejected ||
            data?.status == AppStatus.delivered ||
            data?.isToday == false
        ? SizedBox()
        : Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isVendor
                  ? Column(
                    children: [
                      FillButtonWidget(
                        bgColor: AppColor.black,
                        title: 'Reject',
                        onPressed: () {
                          widgetRejectConfirm();
                        },
                      ),
                      Gap(h: 10),
                      FillButtonWidget(
                        title: 'Mark as Delivered',
                        onPressed: () {
                          subscriptionOrderVendorDeliveryAPI();
                        },
                      ),
                    ],
                  )
                  : FillButtonWidget(
                    bgColor: AppColor.black,
                    title: 'Cancel',
                    onPressed: () {
                      widgetCancelConfirm();
                    },
                  ),
            ],
          ),
        );
  }

  void subscriptionOrderVendorDeliveryAPI() {
    _commonBloc.subscriptionOrderVendorDeliveryAPI(data?.id);
  }

  void subscriptionOrderUserCancelAPI(String reason) {
    _commonBloc.subscriptionOrderUserCancelAPI(data?.id, reason);
  }

  void subscriptionOrderVendorRejectAPI(String reason) {
    _commonBloc.subscriptionOrderVendorRejectAPI(data?.id, reason);
  }

  void widgetCancelConfirm() {
    DialogUtils().widgetCancelUserOnDemandDialog(
      context: context,
      callback: (String reason) async {
        Navigator.pop(context);
        subscriptionOrderUserCancelAPI(reason);
      },
    );
  }

  void widgetRejectConfirm() {
    DialogUtils().widgetCancelUserOnDemandDialog(
      context: context,
      callback: (String reason) async {
        Navigator.pop(context);
        subscriptionOrderVendorRejectAPI(reason);
      },
    );
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
        case ApiType.SUBSCRIPTION_ORDER_USER_CANCEL:
        case ApiType.SUBSCRIPTION_ORDER_VENDOR_REJECT:
        case ApiType.SUBSCRIPTION_ORDER_VENDOR_DELIVERED:
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
