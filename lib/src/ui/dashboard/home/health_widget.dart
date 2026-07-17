import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/fill_button_widget.dart';
import '../../detail/create_subscription_page.dart';

class HealthWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const HealthWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<HealthWidget> createState() => _HealthWidgetState();
}

class _HealthWidgetState extends State<HealthWidget> {
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
    final fitnessProducts = getProductsByCategory('fitness_meals');
    _dataStream.sink.add(fitnessProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_widgetTodayOrder()],
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
                str: 'Healthy Meals (${data?.length})',
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
    return InkWell(
      onTap: () {
        AppUtils.launchScreen(context, CreateSubscriptionPage(product: product));
      },
      child: SizedBox(
        width: SCREEN_WIDTH - gap,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 0),
          child: SizedBox(
            width: SCREEN_WIDTH - 80,
            child: CustomCard(
              elevation: 1,
              child: Stack(
                children: [
                  CacheImage(url: image, w: SCREEN_WIDTH, h: 190),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                        colors: [
                          AppColor.trans,
                          AppColor.black.withOpacity(0.7),
                          AppColor.black.withOpacity(1),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  if (AppUtils.getDouble(product?.rating) != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  str: '${product?.rating}',
                                  color: AppColor.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Gap(h: 10),
                        TextSemi(
                          str: AppUtils.formatStatus(product?.category),
                          color: AppColor.white,
                          size: 16,
                        ),
                        Gap(h: 2),
                        TextRegular(str: product?.name, color: AppColor.white, size: 13),
                        Gap(h: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextSemi(
                                str: product?.title,
                                color: AppColor.white,
                                size: 14,
                              ),
                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
