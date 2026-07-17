import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';

class AddReviewPage extends StatefulWidget {
  final int? productId;

  const AddReviewPage({super.key, required this.productId});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  late CommonBloc _commonBloc;
  TextEditingController commentController = TextEditingController();
  double rating = 0;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Add Product Rate & Review',
      isBottom: false,

      child: SingleChildScrollView(child: _widgetReview()),
    );
  }

  Widget _widgetReview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.color_B0B0B0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: "Rate & Review", size: 18, color: AppColor.black),
          TextRegular(str: "How was your meal?", size: 14, color: AppColor.color_B0B0B0),
          Gap(h: 10),
          _ratingBar(),
          Gap(h: 25),

          TextField(
            controller: commentController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: "Write your review...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          Gap(h: 20),

          FillButtonWidget(
            title: 'Submit Review',
            onPressed: () {
              createReviewProductAPI();
            },
          ),
        ],
      ),
    );
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0.5,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 42,
      glow: false,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
      onRatingUpdate: (value) {
        setState(() {
          rating = value;
        });
      },
    );
  }

  void createReviewProductAPI() {
    bool isOK = true;
    String review = commentController.text.trim();
    if (rating == 0) {
      AppUtils.showToast('Rating is required');
      isOK = false;
    }
    if (AppUtils.isBlank(review)) {
      AppUtils.showToast('Review comment is required');
      isOK = false;
    }

    if (isOK) {
      _commonBloc.createReviewProductAPI(widget.productId, rating, review);
    }
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
        case ApiType.REVIEW_CREATE:
          {
            var res = CommonResponse.fromJson(map);
            AppUtils.showToast(res.message);
            Navigator.pop(context);
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
