import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/order/one/OneTimeOrderData.dart';
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
import '../review/AddReviewPage.dart';

class OneTimeOrderDetailPage extends StatefulWidget {
  final OneTimeOrderData? data;

  const OneTimeOrderDetailPage({super.key, required this.data});

  @override
  State<OneTimeOrderDetailPage> createState() => _OneTimeOrderDetailPageState();
}

class _OneTimeOrderDetailPageState extends State<OneTimeOrderDetailPage> {
  late CommonBloc _commonBloc;
  OneTimeOrderData? data;
  bool isUser = true;

  @override
  void initState() {
    data = widget.data;
    isUser = USER_DATA?.userType == UserType.USER;
    print('isUser $isUser');
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'One Time Order Detail',
      isBottom: false,
      bottom: _widgetBottom(),
      support: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.support_agent, color: Colors.red, size: 26),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _widgetImage(widget.data),
            Gap(h: 15),
            _card("User Information", [
              _row("Name", data?.user?.name),
              InkWell(
                onTap: () {
                  AppUtils.makePhoneCall(data?.user?.phoneNumber);
                },
                child: _row("Phone Number", data?.user?.phoneNumber, copy: Icons.call),
              ),
            ]),

            _card("Order Information", [
              _row("Order ID", 'ORD#_${widget.data?.id}'),
              _row(
                "Delivery Date",
                TimeUtils.getOneTimeTitle(
                  widget.data?.deliveryDate,
                  widget.data?.mealType,
                ),
              ),
              _row("Meal Type", AppUtils.formatStatus(widget.data?.mealType)),
              _row("Quantity", "${widget.data?.quantity} Thalis"),
              _row("Order Status", AppStatus.getStatus(widget.data?.status)),
            ]),

            if (isUser == true) _widgetReview(data?.product?.id),

            _card("Vendor Information", [_row(data?.product?.vendor?.name, '')]),

            _card("Payment Summary", [
              _row("Price / Thali", AppUtils.formatPrice(widget.data?.amount)),
              _row("Quantity", '${widget.data?.quantity}'),
              _row(
                "Items",
                '${widget.data?.quantity} X ${AppUtils.formatPrice(widget.data?.amount)}',
              ),
              const Divider(),
              _row("Payable Amount", AppUtils.formatPrice(widget.data?.finalAmount)),
            ]),

            _card("Vendor Address", [
              InkWell(
                onTap: () {
                  AppUtils.openGoogleMap(
                    data?.product?.vendor?.address?.latitude,
                    data?.product?.vendor?.address?.longitude,
                  );
                },
                child: _row(
                  data?.product?.vendor?.address?.fullAddress,
                  '',
                  copy: !isUser ? null : Icons.location_on,
                ),
              ),
            ]),

            _card("Customer Delivery Address", [
              InkWell(
                onTap: () {
                  AppUtils.openGoogleMap(
                    data?.address?.latitude,
                    data?.address?.longitude,
                  );
                },
                child: _row(data?.address?.fullAddress, '', copy: Icons.location_on),
              ),
            ]),

            _card("Delivery Boy", [
              _row("Name", data?.delivery?.name),
              InkWell(
                onTap: () {
                  AppUtils.makePhoneCall(data?.delivery?.phoneNumber);
                },
                child: _row(
                  "Phone Number",
                  data?.delivery?.phoneNumber,
                  copy: Icons.call,
                ),
              ),
            ]),

            Gap(h: 5),
            RaisedIssueWidget(),

            _card("Meal Description", [
              Row(
                children: [
                  Expanded(
                    child: TextRegular(str: widget.data?.product?.description, size: 14),
                  ),
                ],
              ),
            ]),

            if (AppUtils.isNotBlank(data?.cancelReason))
              _card("User Cancellation Reason", [
                Row(children: [TextRegular(str: data?.cancelReason, size: 15)]),
              ]),

            if (AppUtils.isNotBlank(data?.rejectReason))
              _card("Vendor Rejected Reason", [
                Row(
                  children: [
                    TextRegular(str: data?.rejectReason, size: 15, color: AppColor.black),
                  ],
                ),
              ]),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _widgetImage(OneTimeOrderData? data) {
    var image = AppUtils.getFirstImage(data?.product?.images);
    var product = data?.product;
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
                      str: AppUtils.formatStatus(data?.product?.planType),
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
          children: [TextSemi(str: title, size: 15), Gap(h: 1), ...children],
        ),
      ),
    );
  }

  Widget _row(String? title, String? value, {IconData? copy = null}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget _widgetBottom() {
    var isVendor = USER_DATA?.userType == UserType.VENDOR;
    return data?.status == AppStatus.delivered ||
            data?.status == AppStatus.rejected ||
            data?.status == AppStatus.cancelled ||
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
                          oneTimeVendorDeliveryAPI();
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

  Widget _widgetReview(int? productId) {
    if (data?.status == AppStatus.delivered)
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppUtils.launchScreen(context, AddReviewPage(productId: productId));
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

  void oneTimeVendorDeliveryAPI() {
    _commonBloc.oneTimeVendorDeliveryAPI(data?.id);
  }

  void oneTimeUserOrderCancelAPI(String reason) {
    _commonBloc.oneTimeUserOrderCancelAPI(data?.id, reason);
  }

  void oneTimeVendorRejectAPI(String reason) {
    _commonBloc.oneTimeVendorRejectAPI(data?.id, reason);
  }

  void widgetCancelConfirm() {
    DialogUtils().widgetCancelUserOnDemandDialog(
      context: context,
      callback: (String reason) async {
        Navigator.pop(context);
        oneTimeUserOrderCancelAPI(reason);
      },
    );
  }

  void widgetRejectConfirm() {
    DialogUtils().widgetCancelUserOnDemandDialog(
      context: context,
      callback: (String reason) async {
        Navigator.pop(context);
        oneTimeVendorRejectAPI(reason);
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
        case ApiType.ONE_TIME_USER_CANCEL:
        case ApiType.ONE_TIME_VENDOR_REJECT:
        case ApiType.ONE_TIME_VENDOR_DELIVERED:
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
