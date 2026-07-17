import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/rating_widget.dart';
import '../../detail/create_subscription_page.dart';

class TrendingWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const TrendingWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<TrendingWidget> createState() => _TrendingWidgetState();
}

class _TrendingWidgetState extends State<TrendingWidget> {
  final StreamController<List<ProductModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    List<ProductModel>? sortedProducts = [...(widget.products ?? [])]
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    _dataStream.sink.add(sortedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Gap(h: 10), _widgetTodayOrder()],
    );
  }

  Widget _widgetTodayOrder() {
    return CommonStreamBuilder<List<ProductModel>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Trending Now (${data?.length})',
                size: 16,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 280,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var product = data?[index];
                  return _widgetItemUI(product, data?.length);
                },
              ),
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetItemUI(ProductModel? product, int? length) {
    var gap = length == 1 ? 20 : 80;
    var image = AppUtils.getFirstImage(product?.images);
    var discount = AppUtils.getDouble(product?.offer?.discountAmount);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, CreateSubscriptionPage(product: product));
        },
        child: SizedBox(
          width: SCREEN_WIDTH - gap,
          child: CustomCard(
            elevation: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CacheImage(url: image, w: SCREEN_WIDTH, h: 150),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.trans,
                            AppColor.black.withOpacity(0.1),
                            AppColor.black.withOpacity(1),
                          ],
                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextRegular(
                                str: AppUtils.formatStatus(product?.category),
                                color: AppColor.white,
                                size: 14,
                              ),
                              Gap(h: 10),
                              FixButtonWidget(
                                width: 120,
                                height: 26,
                                color: AppColor.red,
                                borderColor: AppColor.white,
                                child: TextRegular(
                                  str: 'Subscribe Now',
                                  color: AppColor.white,
                                  size: 13,
                                ),
                                onPressed: () {
                                  AppUtils.launchScreen(
                                    context,
                                    CreateSubscriptionPage(product: product),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    RatingWidget(rating: product?.rating, count: product?.totalReviews),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextSemi(
                              str: product?.name,
                              max: 1,
                              color: AppColor.black,
                              size: 16,
                            ),
                          ),
                          if (AppUtils.getDouble(discount) != 0)
                            TextSemi(
                              str: 'Discount: ${AppUtils.formatPrice(discount)}',
                              max: 1,
                              cross: true,
                              color: AppColor.color_0BB53A,
                              size: 11,
                            ),
                        ],
                      ),
                      TextMedium(
                        str: AppUtils.formatStatus(product?.planType),
                        color: AppColor.colorBlue,
                        size: 13,
                      ),
                      Gap(h: 10),
                      TextMedium(
                        str: product?.vendor?.name,
                        color: AppColor.black,
                        max: 1,
                        size: 12,
                      ),
                      Gap(h: 5),
                      Row(
                        children: [
                          TextSemi(
                            str: '${AppUtils.formatPrice(product?.productPrice)}',
                            color: AppColor.colorBlue,
                            size: 15,
                          ),

                          TextMedium(str: '/person', color: AppColor.black, size: 13),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
