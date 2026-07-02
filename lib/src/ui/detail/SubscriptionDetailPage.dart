import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/response/subscription/active/SubscriptionData.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';

class SubscriptionDetailPage extends StatefulWidget {
  final SubscriptionData? data;

  const SubscriptionDetailPage({super.key, required this.data});

  @override
  State<SubscriptionDetailPage> createState() => _SubscriptionDetailPageState();
}

class _SubscriptionDetailPageState extends State<SubscriptionDetailPage> {
  SubscriptionData? data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My Subscription',
      isBottom: false,
      bottom: Container(
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
            const SizedBox(width: 12),
            Expanded(child: FillButtonWidget(onPressed: () {}, title: "Pause")),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _widgetImage(data),
            Gap(h: 15),
            _widgetSubUI(data),
            infoCard(
              title: "Vendor",
              child: Column(children: [infoRow("Name", data?.product?.subOwner?.name)]),
            ),
            infoCard(
              title: "Selected Plan",
              child: Column(
                children: [
                  infoRow("Meal", AppUtils.formatStatus(data?.product?.planType)),
                  infoRow("Plan", "${data?.pricingDetail?.days} Days"),
                  infoRow(
                    "Price",
                    AppUtils.formatPrice(AppUtils.getDouble2(data?.amount)),
                  ),
                ],
              ),
            ),

            infoCard(
              title: "Offer Applied",
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Lean Fit Plan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Coupon: NEW003"),
                      ],
                    ),
                  ),
                  TextSemi(
                    color: Colors.green,
                    size: 15,
                    str: '-${AppUtils.formatPrice(data?.product?.offer?.discountAmount)}',
                  ),
                ],
              ),
            ),

            infoCard(
              title: "Payment Summary",
              child: Column(
                children: [
                  infoRow(
                    "Product Price",
                    AppUtils.formatPrice(data?.pricingDetail?.price),
                  ),
                  infoRow("Quantity", '${data?.quantity}'),
                  infoRow("Subscription", "${data?.pricingDetail?.days} Days"),
                  infoRow(
                    "Discount",
                    '-${AppUtils.formatPrice(data?.product?.offer?.discountAmount)}',
                  ),
                  const Divider(),
                  infoRow(
                    "Total Amount",
                    '${AppUtils.formatPrice(AppUtils.getDouble2(data?.amount))}',
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            infoCard(
              title: "Meal Description",
              child: TextRegular(
                str: data?.product?.description,
                color: AppColor.black,
                size: 13,
              ),
            ),
            const SizedBox(height: 100),
          ],
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
                        str: AppUtils.getOrderStatus(data?.status),
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
          infoRow("Start Date", TimeUtils.parseDate2(data?.startDate)),
          infoRow("End Date", TimeUtils.parseDate2(data?.endDate)),
          infoRow("Duration", '${data?.pricingDetail?.days} Days'),
          infoRow("Quantity", "${data?.quantity} Thalis"),
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

  Widget infoRow(String title, String? value, {TextStyle? valueStyle}) {
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
}
