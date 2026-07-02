import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../model/response/order/sub/SubTodayOrderData.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../utils/gap.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';

class SubscriptionOrderDetailPage extends StatelessWidget {
  final SubTodayOrderData? data;

  const SubscriptionOrderDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Subscription Order Detail',
      isBottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _widgetImage(data),
            Gap(h: 15),

            /// DELIVERY
            _card("Today's Delivery", [
              _row("Delivery Date", data?.deliveryDate),
              _row("Meal", AppUtils.formatStatus(data?.mealType)),
              _row("Quantity", "${data?.quantity} Tiffins"),
            ]),

            /// SUBSCRIPTION
            _card("Subscription Information", [
              _row("Subscription ID", "#170"),
              _row("Subscription Status", AppUtils.getOrderStatus(data?.status)),
              _row("Plan", AppUtils.formatStatus(data?.product?.planType)),
              _row("Created On", data?.createdAt),
            ]),

            /// VENDOR
            _card("Vendor Details", [_row("Vendor", data?.product?.subOwner?.name)]),

            /// TODAY'S MENU
            _card("Today's Meal", [
              TextRegular(str: data?.product?.description, size: 14),
            ]),

            /// PRICING
            _card("Pricing", [
              _row("Price Per Meal", ''),
              _row("Today's Quantity", "${data?.quantity}"),
              const Divider(),
              _row(
                "Today's Amount",
                "₹380",
                valueStyle: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ]),

            /// AVAILABLE PLANS
            _card("Subscription Plans", [
              _planTile("20 Days", "₹3,600", false),
              const SizedBox(height: 10),
              _planTile("26 Days", "₹4,600", true),
              const SizedBox(height: 10),
              _planTile("30 Days", "₹5,600", false),
            ]),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _widgetImage(SubTodayOrderData? data) {
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

  static Widget _row(String? title, String? value, {TextStyle? valueStyle}) {
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

  Widget _planTile(String days, String price, bool bestOffer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: bestOffer ? Colors.green : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month),

          const SizedBox(width: 12),

          Expanded(
            child: Text(days, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),

          if (bestOffer)
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "BEST OFFER",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),

          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
