import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_medium.dart';
import '../../../widget/test_semi.dart';
import '../../detail/create_subscription_page.dart';

class RecommendWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const RecommendWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<RecommendWidget> createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {
  final StreamController<List<ProductModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    _dataStream.sink.add(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(h: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextBold(str: 'Recommended for You', size: 16, color: AppColor.black),
        ),
        Gap(h: 10),
        _widgetTab(),
        Gap(h: 10),
        _widgetTodayOrder(),
      ],
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetItemUI(today, data?.length);
              },
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Gap(w: 15),
          _widgetItem('All', 1),
          _widgetItem('Breakfast', 2),
          _widgetItem('Lunch', 3),
          _widgetItem('Dinner', 4),
        ],
      ),
    );
  }

  int _selectedTab = 1;

  Widget _widgetItem(String str, int type) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: FixButtonWidget(
        color: _selectedTab == type ? AppColor.colorBlue : AppColor.white,
        borderColor: AppColor.colorBlue.withOpacity(0.3),
        height: 36,
        child: Row(
          children: [
            Gap(w: 12),
            Icon(
              Icons.all_inbox,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 15,
            ),
            Gap(w: 6),
            TextRegular(
              str: str,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 14,
            ),
            Gap(w: 15),
          ],
        ),
        onPressed: () {
          _selectedTab = type;
          var p = getFilteredProducts();
          _dataStream.sink.add(p);
          setState(() {});
        },
      ),
    );
  }

  Widget _widgetItemUI(ProductModel? product, int? length) {
    var image = AppUtils.getFirstImage(product?.images);
    var p = AppUtils.getLength(product?.pricingOptions?.length);
    var price1 = product?.pricingOptions?[0].price;
    var price2 = product?.pricingOptions?[p - 1].price;

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: FixButtonWidget(
        radius: 15,
        borderColor: AppColor.white,
        elevation: 1,
        onPressed: () {
          AppUtils.launchScreen(context, CreateSubscriptionPage(product: product));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CacheImage(round: 15, url: image, w: 110, h: 110),
            ),
            Gap(w: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(h: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextSemi(
                          str: AppUtils.formatStatus(product?.category),
                          max: 1,
                          color: AppColor.black,
                          size: 16,
                        ),
                      ),
                      if (AppUtils.getDouble(product?.rating) != 0)
                        RoundedContainer(
                          color: AppColor.color_F4C102,
                          child: Row(
                            children: [
                              Gap(w: 2),
                              Icon(Icons.star, color: AppColor.black, size: 13),
                              Gap(w: 2),
                              TextSemi(
                                str: '${product?.rating}',
                                color: AppColor.black,
                                size: 11,
                              ),
                              Gap(w: 6),
                            ],
                          ),
                        ),
                      Gap(w: 10),
                    ],
                  ),
                  Gap(h: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextMedium(
                          str: product?.name,
                          color: AppColor.black,
                          size: 14,
                        ),
                      ),
                      TextMedium(
                        str: AppUtils.formatStatus(product?.planType),
                        color: AppColor.colorBlue,
                        size: 12,
                      ),
                      Gap(w: 10),
                    ],
                  ),

                  Gap(h: 6),
                  Row(
                    children: [
                      TextSemi(
                        str: AppUtils.formatPrice(price1),
                        color: AppColor.black,
                        size: 13,
                      ),
                      TextSemi(str: ' - ', color: AppColor.black, size: 13),
                      TextSemi(
                        str: AppUtils.formatPrice(price2),
                        color: AppColor.black,
                        size: 13,
                      ),
                    ],
                  ),
                  Gap(h: 6),
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
                  Gap(h: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProductModel> getFilteredProducts() {
    final products = widget.products ?? [];

    switch (_selectedTab) {
      case 1: // All
        return products;

      case 2: // Breakfast
        return products.where((p) => p.planType!.contains('breakfast')).toList();

      case 3: // Lunch
        return products.where((p) => p.planType!.contains('lunch')).toList();

      case 4: // Dinner
        return products.where((p) => p.planType!.contains('dinner')).toList();

      default:
        return products;
    }
  }
}
