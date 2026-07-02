import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../model/response/order/one/OneTimeOrderData.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../utils/gap.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';

class OneTimeOrderDetailPage extends StatelessWidget {
  final OneTimeOrderData? data;

  const OneTimeOrderDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Order Detail',
      isBottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _widgetImage(data),
            Gap(h: 15),
            _card("Order Information", [
              _row("Order ID", "#00003"),
              _row("Delivery Date", data?.deliveryDate),
              _row("Meal Type", AppUtils.formatStatus(data?.mealType)),
              _row("Quantity", "${data?.quantity} Thalis"),
              _row("Order Status", AppUtils.getOrderStatus(data?.status)),
            ]),

            _card("Vendor Information", [_row("Vendor", data?.subOwner?.name)]),

            _card("Delivery Address", [_row(data?.address?.fullAddress, '')]),

            _card("Payment Summary", [
              _row("Price / Tiffin", AppUtils.formatPrice(data?.product?.productPrice)),
              _row("Quantity", '${data?.quantity}'),
              _row("Subtotal", AppUtils.formatPrice(AppUtils.getDouble2(data?.amount))),
              const Divider(),
              _row(
                "Final Amount",
                AppUtils.formatPrice(AppUtils.getDouble2(data?.amount)),
                valueStyle: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ]),

            _card("Meal Description", [
              TextRegular(str: data?.product?.description, size: 14),
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
}
