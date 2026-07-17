import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/vendor/detail/vendor_today_order_widget.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/fonts.dart';
import '../../../model/response/vendor/list/UserOrder.dart';
import '../../../utils/app_utils.dart';
import '../../dashboard/home/today/active_subscription_widget.dart';
import '../TabBarDelegate.dart';
import '../demand/vendor_on_demand_list_page.dart';
import 'VendorUserOrderWidget.dart';

class UserDetailPage extends StatefulWidget {
  final UserOrder? user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  UserOrder? user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ScaffoldWidget(
        title: user?.name,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _userInfoCard(),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: TabBarDelegate(
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    labelColor: AppColor.black,
                    labelStyle: TextStyle(fontSize: 14, fontFamily: Fonts.SEMI_BOLD),
                    unselectedLabelColor: AppColor.color_B0B0B0,
                    tabs: const [
                      Tab(text: "Today's Order"),
                      Tab(text: "All Order's"),
                      Tab(text: "Subscriptions"),
                      Tab(text: "On Demand Order's"),
                    ],
                  ),
                ),
              ),
            ];
          },

          body: TabBarView(
            children: [
              VendorTodayOrderWidget(userId: user?.id),
              VendorUserOrderWidget(userId: user?.id),
              ActiveSubscriptionWidget(userId: user?.id),
              VendorOnDemandPageList(userId: user?.id),
            ],
          ),
        ),
      ),
    );
  }

  /// USER INFO
  Widget _userInfoCard() {
    return Container(
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 5, bottom: 10, top: 10),
        child: Row(
          children: [
            RoundedContainer(
              width: 50,
              rounded: 50,
              height: 50,
              child: Text(
                user?.name?.substring(0, 1).toUpperCase() ?? "U",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  AppUtils.makePhoneCall(user?.phoneNumber);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemi(str: user?.name ?? ""),
                          TextRegular(str: user?.phoneNumber, line: true, size: 14),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppUtils.copyText(context, user?.phoneNumber);
                      },
                      icon: Icon(Icons.copy, size: 22, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
