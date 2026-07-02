import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/shimmer/CustomShimmer.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../detail/CategoryPage.dart';

class CategoryWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const CategoryWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final StreamController<List<CategoryModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    final sortedProducts = [...(widget.products ?? [])]
      ..sort((a, b) => (b.avgRating ?? 0).compareTo(a.avgRating ?? 0));

    final Map<String, CategoryModel> categoryMap = {};

    for (final product in sortedProducts ?? []) {
      categoryMap.putIfAbsent(
        product.category,
        () => CategoryModel(
          category: product.category,
          image: product.images.isNotEmpty ? product.images.first : null,
        ),
      );
    }

    final List<CategoryModel> categories = categoryMap.values.toList();
    _dataStream.sink.add(categories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Gap(h: 10), _widgetTodayOrder()],
    );
  }

  Widget _widgetTodayOrder() {
    return CommonStreamBuilder<List<CategoryModel>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Top Category (${data?.length})',
                size: 16,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            SizedBox(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: AppUtils.getLength(data?.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var cat = data?[index];
                  return _widgetItemUI(cat);
                },
              ),
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetItemUI(CategoryModel? cat) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(
            context,
            CategoryPage(category: cat?.category, products: widget.products),
          );
        },
        child: SizedBox(
          width: 200,
          child: CustomCard(
            elevation: 1,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CacheImage(url: cat?.image, w: SCREEN_WIDTH, h: 120),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.black.withOpacity(0.1),
                        AppColor.black.withOpacity(0.5),
                        AppColor.black.withOpacity(1),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: TextSemi(
                    str: AppUtils.formatStatus(cat?.category),
                    color: AppColor.white,
                    size: 17,
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
