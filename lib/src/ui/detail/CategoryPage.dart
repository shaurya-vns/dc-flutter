import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/response/product/ProductModel.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/cache_image.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/custome_card.dart';
import '../../widget/fix_button_widget.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_medium.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../dashboard/home/recommend_widget.dart';
import '../shimmer/CustomShimmer.dart';
import 'create_subscription_page.dart';

class CategoryPage extends StatefulWidget {
  final String? category;
  final List<ProductModel>? products;

  const CategoryPage({Key? key, required this.category, required this.products})
    : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with BaseMixin {
  final StreamController<List<ProductModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  List<ProductModel> getProductsByCategory(String category) {
    return (widget.products ?? [])
        .where((product) => product.category == category)
        .toList();
  }

  onPostFrameCallback(BuildContext context) {
    final fitnessProducts = getProductsByCategory(widget.category!);
    _dataStream.sink.add(fitnessProducts);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: AppUtils.formatStatus(widget.category),
      isBottom: false,
      child: SingleChildScrollView(scrollDirection: Axis.vertical, child: _widgetUI()),
    );
  }

  Widget _widgetUI() {
    return CommonStreamBuilder<List<ProductModel>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetCategoryUI(data),
            RecommendWidget(products: widget.products),
            Gap(h: 100),
          ],
        );
      },
    );
  }

  Widget _widgetCategoryUI(List<ProductModel>? data) {
    return CommonStreamBuilder<List<ProductModel>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    var gap = length == 1 ? 40 : 80;
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
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (AppUtils.getDouble(product?.avgRating) != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundedContainer(
                              width: 65,
                              height: 24,
                              rounded: 30,
                              border: AppColor.colorBlue,
                              color: AppColor.colorBlue,
                              child: Row(
                                children: [
                                  Gap(w: 10),
                                  Icon(Icons.star, color: AppColor.white, size: 15),
                                  Gap(w: 4),
                                  TextSemi(
                                    str: '${product?.avgRating}',
                                    color: AppColor.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        str: product?.subOwner?.name,
                        color: AppColor.black,
                        max: 1,
                        size: 12,
                      ),
                      TextMedium(str: '12 KM', color: AppColor.black, size: 12),
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
