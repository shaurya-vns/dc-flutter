import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/review/ReviewResponse.dart';
import 'package:flutter_dc/src/widget/test_light.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/review/ReviewData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/test_bold.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';

class ProductReviewWidget extends StatefulWidget {
  final int? productId;

  const ProductReviewWidget({super.key, required this.productId});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  late CommonBloc _commonBloc;

  final StreamController<List<ReviewData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return _widgetReview();
  }

  Widget _widgetReview() {
    return CommonStreamBuilder<List<ReviewData>?>(
      stream: _dataStream.stream,
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(h: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextBold(
                str: 'Reviews (${data?.length})',
                size: 15,
                color: AppColor.black,
              ),
            ),
            Gap(h: 10),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var review = data?[index];
                return _widgetItem(review);
              },
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetItem(ReviewData? review) {
    var chrName = AppUtils.getFirstValue(review?.userName);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.lightGreenAccent,
            child: TextSemi(str: chrName, color: AppColor.black, size: 17),
          ),
          Gap(w: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemi(str: review?.userName, size: 17),
                TextLight(str: review?.review, size: 14, color: AppColor.black),
              ],
            ),
          ),
          Gap(w: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextRegular(str: '${review?.rating}', size: 13, color: AppColor.black),
              const SizedBox(width: 2),
              const Icon(Icons.star, size: 15, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  void getOrder() {
    _commonBloc.getProductReviewListAPI(widget.productId);
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {
        case ApiType.REVIEW_LIST:
          {
            var res = ReviewResponse.fromJson(map);
            _dataStream.sink.add(res.data);
          }
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
