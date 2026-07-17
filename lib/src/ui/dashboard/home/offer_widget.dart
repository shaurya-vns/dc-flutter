import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/product/ProductModel.dart';
import 'package:flutter_dc/src/ui/detail/create_subscription_page.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/rating_widget.dart';

class OfferWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const OfferWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  final StreamController<List<ProductModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    final offerProducts =
        (widget.products ?? [])
            .where((product) => product.offer?.isActive == true)
            .toList();
    _dataStream.sink.add(offerProducts);
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
                str: 'Today\'s Offers (${data?.length})',
                size: 16,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 190,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var offer = data?[index];
                  return _widgetItemUI(offer, data?.length);
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
    var gap = length == 1 ? 20 : 40;
    var offer = product?.offer;
    var image = AppUtils.getFirstImage(product?.images);
    var discount = AppUtils.formatPrice(AppUtils.getDouble(offer?.discountAmount));
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, CreateSubscriptionPage(product: product));
        },
        child: SizedBox(
          width: SCREEN_WIDTH - gap,
          child: CustomCard(
            elevation: 1,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CacheImage(url: image, w: SCREEN_WIDTH, h: 190),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        AppColor.trans,
                        AppColor.color_F4C102.withOpacity(0.8),
                        AppColor.color_F4C102.withOpacity(1),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextSemi(
                              str: '$discount OFF',
                              color: AppColor.black,
                              size: 22,
                            ),
                          ),
                          RatingWidget(
                            rating: product?.rating,
                            count: product?.totalReviews,
                          ),
                          Gap(w: 13),
                        ],
                      ),
                      TextRegular(
                        str: 'Avail this discount\non your first order*',
                        color: AppColor.black,
                        size: 14,
                      ),
                      Gap(h: 10),
                      RoundedContainer(
                        width: 80,
                        alignment: Alignment.centerLeft,
                        rounded: 3,
                        height: 25,
                        border: AppColor.white,
                        color: AppColor.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextSemi(
                            str: offer?.code,
                            color: AppColor.black,
                            size: 12,
                          ),
                        ),
                      ),
                      Gap(h: 7),
                      TextRegular(str: offer?.name, color: AppColor.white, size: 15),
                      Gap(h: 3),
                      TextSemi(
                        str: AppUtils.formatStatus(product?.planType),
                        color: AppColor.black,
                        size: 13,
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
