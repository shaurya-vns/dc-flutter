import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/model/response/product/PricingDetail.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/base_error.dart';
import '../../model/common_response.dart';
import '../../model/response/subscription/active/SubscriptionData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/AppStatus.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../common_bloc.dart';

class SubscriptionDetailPage extends StatefulWidget {
  final SubscriptionData? data;

  const SubscriptionDetailPage({super.key, required this.data});

  @override
  State<SubscriptionDetailPage> createState() => _SubscriptionDetailPageState();
}

class _SubscriptionDetailPageState extends State<SubscriptionDetailPage> {
  late CommonBloc _commonBloc;
  SubscriptionData? data;
  bool isUser = true;

  @override
  void initState() {
    data = widget.data;
    isUser = AppUtils.isUser();
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      progressLoaderStream: _commonBloc.progressLoaderStream,
      child: ScaffoldWidget(
        title: isUser ? 'My Subscription Detail' : ' User Subscription Detail',
        isBottom: false,
        bottom: _widgetBottomUI(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _widgetImage(data),
              Gap(h: 10),
              infoCard(
                title: "User Information",
                child: Column(
                  children: [
                    infoRow("Name", data?.user?.name),
                    infoRow("Phone Number", data?.user?.phoneNumber),
                  ],
                ),
              ),
              _widgetSubUI(data),
              infoCard(
                title: "Vendor",
                child: Column(children: [infoRow("Name", data?.product?.vendor?.name)]),
              ),
              infoCard(
                title: "Selected Plan",
                child: Column(
                  children: [
                    infoRow("Meal", AppUtils.formatStatus(data?.product?.planType)),
                    infoRow("Plan", "${data?.pricingDetail?.days} Days"),
                    infoRow(
                      "Plan Price",
                      AppUtils.formatPrice(data?.pricingDetail?.price),
                    ),
                  ],
                ),
              ),
              infoCard(
                title: "Delivery Address",
                child: Column(children: [infoRow(data?.address?.fullAddress, '')]),
              ),

              if (data?.product?.offer != null)
                infoCard(
                  title: "Offer Applied",
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextSemi(str: data?.product?.offer?.name),
                            Text("CODE: ${data?.product?.offer?.code}"),
                          ],
                        ),
                      ),
                      TextSemi(
                        color: Colors.green,
                        size: 15,
                        str:
                            '-${AppUtils.formatPrice(data?.product?.offer?.discountAmount)}',
                      ),
                    ],
                  ),
                ),

              infoCard(
                title: "Payment Summary",
                child: Column(
                  children: [
                    infoRow(
                      "Subscription Price",
                      AppUtils.formatPrice(data?.originalPrice),
                    ),
                    infoRow("Quantity", '${data?.quantity}'),
                    infoRow(
                      "Discount",
                      '-${AppUtils.formatPrice(data?.product?.offer?.discountAmount)}',
                    ),
                    const Divider(),
                    infoRow(
                      "Payable Amount",
                      '${AppUtils.formatPrice(data?.amount)}',
                      valueStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: AppUtils.getLength(data?.product?.pricingOptions?.length),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var pO = data?.product?.pricingOptions?[index];
                  return _planTile(pO, data?.pricingDetail);
                },
              ),

              Gap(h: 10),
              infoCard(
                title: "Meal Description",
                child: Row(
                  children: [
                    Expanded(
                      child: TextRegular(
                        str: data?.product?.description,
                        color: AppColor.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetImage(SubscriptionData? data) {
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
                      str: AppUtils.formatStatus(data?.product?.planType),
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

  Widget _widgetSubUI(SubscriptionData? data) {
    return infoCard(
      title: "Subscription",
      child: Column(
        children: [
          infoRow("Subscription Number", 'SUB_${data?.subNumber}'),
          infoRow("Start Date", TimeUtils.parseDate2(data?.startDate)),
          infoRow("End Date", TimeUtils.parseDate2(data?.endDate)),
          infoRow("Duration", '${data?.pricingDetail?.days} Days'),
          infoRow("Quantity", "${data?.quantity} Thalis"),
          infoRow("Payment Status", AppStatus.getStatus(data?.paymentStatus)),
        ],
      ),
    );
  }

  Widget infoCard({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: RoundedContainer(
        rounded: 10,
        color: AppColor.white,
        padding: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TextSemi(str: title, size: 17), Gap(h: 3), child],
        ),
      ),
    );
  }

  Widget infoRow(String? title, String? value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TextRegular(str: title, color: AppColor.black, size: 15)),
          TextSemi(str: value, align: 1, color: AppColor.black, size: 15),
        ],
      ),
    );
  }

  Widget _planTile(PricingDetail? pO, PricingDetail? p1) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 5),
      child: RoundedContainer(
        border: AppColor.trans,
        color: pO?.days == p1?.days ? AppColor.color_DE6262 : AppColor.borderColor,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: pO?.days == p1?.days ? AppColor.white : AppColor.black,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextSemi(
                  str: '${pO?.days}',
                  color: pO?.days == p1?.days ? AppColor.white : AppColor.black,
                ),
              ),
              TextSemi(
                str: AppUtils.formatPrice(pO?.price),
                color: pO?.days == p1?.days ? AppColor.white : AppColor.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetBottomUI() {
    if (data?.paymentStatus == AppStatus.paymentReceived) return SizedBox();

    /*   if (isUser) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: FillButtonWidget(
                bgColor: AppColor.black,
                onPressed: () {},
                title: "Cancel",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: FillButtonWidget(onPressed: () {}, title: "Pause")),
          ],
        ),
      );
    } else {*/
    return data?.paymentStatus == AppStatus.paymentPending
        ? Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FillButtonWidget(
                onPressed: () {
                  subscriptionApproveAPI();
                },
                title: "Approved Subscription",
              ),
            ],
          ),
        )
        : SizedBox();
    //}
  }

  void subscriptionApproveAPI() {
    var subId = widget.data?.id;
    _commonBloc.subscriptionApproveAPI(subId);
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
        case ApiType.SUBSCRIPTION_APPROVE:
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
