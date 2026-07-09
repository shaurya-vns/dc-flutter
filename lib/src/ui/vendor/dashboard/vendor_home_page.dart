import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/vendor/list/UserListResponse.dart';
import '../../../model/response/vendor/list/UserOrder.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_bold.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';
import '../detail/UserDetailPage.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  late CommonBloc _commonBloc;

  final StreamController<List<UserOrder>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getAllUserList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.color_bg,
        extendBody: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColor.color_bg,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getAllUserList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(children: [_widgetHeader(), _widgetUserUI()]),
          ),
        ),
      ),
    );
  }

  Widget _widgetUserUI() {
    return CommonStreamBuilder<List<UserOrder>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      nothing: Container(
        height: 300,
        alignment: Alignment.center,
        child: TextSemi(str: 'No data found yet'),
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(h: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Total Today\'s Users (${data?.length})',
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 6),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetItemUI(today);
              },
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetItemUI(UserOrder? user) {
    final int subscription = user?.subscriptionOrderCount ?? 0;
    final int oneTime = user?.oneTimeOrderCount ?? 0;
    final int total = subscription + oneTime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          AppUtils.launchScreen(context, UserDetailPage(user: user));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// Top Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColor.primaryColor.withOpacity(.12),
                      child: Text(
                        (user?.name ?? "U").substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemi(
                            str: user?.name,
                            size: 16,
                            color: AppColor.black,
                            max: 1,
                          ),

                          const SizedBox(height: 1),

                          Row(
                            children: [
                              const Icon(Icons.phone, size: 15, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: TextRegular(
                                  str: user?.phoneNumber,
                                  size: 13,
                                  color: Colors.grey.shade700,
                                  max: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 33,
                      height: 33,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: total == 0 ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextBold(
                        str: "$total",
                        size: 14,
                        color: total == 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _orderTile(
                        title: "Subscription Order",
                        count: subscription,
                        color: Colors.blue,
                        icon: Icons.repeat,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: _orderTile(
                        title: "One Time Order",
                        count: oneTime,
                        color: Colors.orange,
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Divider(height: 1),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: AppColor.primaryColor,
                      size: 18,
                    ),

                    const SizedBox(width: 6),

                    TextRegular(
                      str: "View Orders",
                      color: AppColor.primaryColor,
                      size: 14,
                    ),

                    const Spacer(),

                    Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderTile({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4, top: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 3),
          Expanded(child: TextSemi(str: title, color: color, size: 12)),
          TextBold(str: "$count", size: 15, color: color),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _widgetHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FixButtonWidget(
                  onPressed: () {},
                  radius: 10,
                  borderColor: AppColor.white,
                  height: 43,
                  child: Row(
                    children: [
                      Gap(w: 10),
                      Image.asset(
                        color: AppColor.black,
                        DrawableConstant.ic_search,
                        width: 23,
                        height: 23,
                      ),
                      Gap(w: 10),
                      TextRegular(str: 'Search by...', size: 16, color: AppColor.black),
                    ],
                  ),
                ),
              ),
              Gap(w: 5),
              ClickWidget(child: Icon(Icons.filter_alt_outlined), onClick: () {}),
            ],
          ),
        ],
      ),
    );
  }

  void getAllUserList() {
    _commonBloc.getAllUserList();
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
        case ApiType.ALL_USER_LIST:
          {
            var res = UserListResponse.fromJson(map);
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
