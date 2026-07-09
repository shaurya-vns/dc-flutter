import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/user/UserData.dart';
import 'package:flutter_dc/src/ui/auth/WelcomePage.dart';
import 'package:flutter_dc/src/ui/detail/MyOneOrderPage.dart';
import 'package:flutter_dc/src/ui/detail/MySubOrderPage.dart';
import 'package:flutter_dc/src/ui/vendor/demand/vendor_on_demand_list_page.dart';
import 'package:flutter_dc/src/utils/preference_util.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/user/UserResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import '../../detail/MySubscriptionPage.dart';
import '../../shimmer/CustomShimmer.dart';

class VendorUserPage extends StatefulWidget {
  const VendorUserPage({Key? key}) : super(key: key);

  @override
  State<VendorUserPage> createState() => _VendorUserPageState();
}

class _VendorUserPageState extends State<VendorUserPage> {
  late CommonBloc _commonBloc;
  final StreamController<UserData?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getUserProfile();
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
              padding: const EdgeInsets.only(top: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Profile Card
                    _widgetUserUI(),

                    const SizedBox(height: 10),

                    /// Orders
                    _sectionTitle("Orders"),

                    _menuCard([
                      _menuTile(
                        Icons.shopping_bag_outlined,
                        "One Time Orders",
                        "View one-time orders",
                        0,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.shopping_bag_outlined,
                        "Subscription Orders",
                        "View subscription orders",
                        1,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.repeat,
                        "Subscriptions",
                        "Manage active subscriptions",
                        2,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.repeat,
                        "On Demand Order",
                        "Manage on demand order's",
                        11,
                      ),
                    ]),

                    /// Legal
                    _sectionTitle("Legal"),

                    _menuCard([
                      _menuTile(Icons.privacy_tip_outlined, "Privacy Policy", "", 6),
                      _divider(),
                      _menuTile(Icons.description_outlined, "Terms & Conditions", "", 7),
                      _divider(),
                      _menuTile(Icons.info_outline, "About Us", "", 8),
                    ]),

                    /// Logout
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 56),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          ACCESS_TOKEN = '';
                          PreferenceUtil.setAccessToken('');
                          AppUtils.launchScreenRemoveAll(context, WelcomePage());
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          "Logout",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextSemi(str: 'Profile', size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetUserUI() {
    return CommonStreamBuilder<UserData?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, profile) {
        var chrName = AppUtils.getFirstValue(profile?.name);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.green,
                child: TextSemi(str: chrName, color: AppColor.white, size: 25),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemi(str: profile?.name, size: 23),
                    SizedBox(height: 5),
                    TextRegular(str: profile?.phoneNumber),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _menuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(IconData icon, String title, String subtitle, int type) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.green.shade50,
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: () {
        print('typetype $type');
        if (type == 0) {
          AppUtils.launchScreen(context, MyOneOrderPage());
        } else if (type == 1) {
          AppUtils.launchScreen(context, MySubOrderPage());
        } else if (type == 2) {
          AppUtils.launchScreen(context, MySubscriptionPage());
        } else if (type == 2) {
          AppUtils.launchScreen(context, MySubscriptionPage());
        }
      },
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }

  void getUserProfile() {
    _commonBloc.getUserProfile();
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
        case ApiType.GET_PROFILE:
          {
            var res = UserResponse.fromJson(map);
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
