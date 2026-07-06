import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/dashboard/home/recommend_widget.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../mixin/BaseMixin.dart';
import '../../../model/base_error.dart';
import '../../../model/response/product/ProductListResponse.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';
import '../home/today/active_subscription_widget.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with BaseMixin {
  late CommonBloc _commonBloc;
  final StreamController<List<ProductModel>?> _productsStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getProductListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(h: 10),
                    ActiveSubscriptionWidget(),
                    _widgetUI(),
                    Gap(h: 150),
                  ],
                ),
              ),
            ),
            searchWidget(),
          ],
        ),
      ),
    );
  }

  Widget _widgetUI() {
    return CommonStreamBuilder<List<ProductModel>?>(
      stream: _productsStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, products) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [RecommendWidget(products: products)],
        );
      },
    );
  }

  void getProductListAPI() {
    print('sssssss getProductBySubOwnerIdAPI  ');
    _commonBloc.getProductListAPI();
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
        case ApiType.PRODUCT_LIST:
          {
            var res = ProductListResponse.fromJson(map);
            print('sssssss data ${res.data}');
            _productsStream.sink.add(res.data);
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
