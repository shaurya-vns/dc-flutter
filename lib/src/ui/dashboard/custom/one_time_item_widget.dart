import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../utils/AppStatus.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/cache_image.dart';
import '../../../utils/ext.dart';
import '../../../utils/time_utils.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../detail/OneTimeOrderDetailPage.dart';

class OneTimeOrderWidget extends StatefulWidget {
  final OneTimeOrderData? oneTimeOrder;

  OneTimeOrderWidget({required this.oneTimeOrder});

  @override
  _OneTimeOrderWidgetState createState() => _OneTimeOrderWidgetState();
}

class _OneTimeOrderWidgetState extends State<OneTimeOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetOneTimeTodayItemUI(widget.oneTimeOrder);
  }

  Widget _widgetOneTimeTodayItemUI(OneTimeOrderData? order) {
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
    String text = AppStatus.getStatus(status);
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
}
