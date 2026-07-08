import 'package:flutter/material.dart';

import '../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../utils/AppStatus.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/cache_image.dart';
import '../../../utils/ext.dart';
import '../../../utils/time_utils.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../detail/SubscriptionOrderDetailPage.dart';

class SubscriptionOrderWidget extends StatefulWidget {
  final SubTodayOrderData? subscriptionOrder;

  SubscriptionOrderWidget({required this.subscriptionOrder});

  @override
  _SubscriptionOrderWidgetState createState() => _SubscriptionOrderWidgetState();
}

class _SubscriptionOrderWidgetState extends State<SubscriptionOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetSubscriptionUI(widget.subscriptionOrder);
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextSemi(str: product?.name, size: 15, max: 1),
                                    TextRegular(
                                      size: 13,
                                      str: AppUtils.formatStatus(product?.category),
                                      color: Colors.grey,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              _statusChip(order?.status),
                            ],
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
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined, size: 16),
                    SizedBox(width: 6),
                    TextRegular(str: "Order #${order?.id}", size: 15),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: TextRegular(
                        size: 15,
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
          TextRegular(str: text, color: color, size: 13),
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
