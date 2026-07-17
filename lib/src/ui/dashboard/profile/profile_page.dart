import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/user/UserData.dart';
import 'package:flutter_dc/src/ui/auth/WelcomePage.dart';
import 'package:flutter_dc/src/ui/demand/user_demand_list_page.dart';
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
import '../../address/MyAddressPage.dart';
import '../../common_bloc.dart';
import '../../contact/MyContactUsPage.dart';
import '../../detail/MyOneOrderPage.dart';
import '../../detail/MySubOrderPage.dart';
import '../../detail/MySubscriptionPage.dart';
import '../../shimmer/CustomShimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    _sectionTitle("Orders"),
                    _menuCard([
                      _menuTile(
                        Icons.shopping_bag_outlined,
                        "My One Time Orders",
                        "View your one-time orders",
                        0,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.favorite_border_rounded,
                        "My Subscription Orders",
                        "View your subscription orders",
                        1,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.repeat,
                        "My Subscriptions",
                        "Manage active subscriptions",
                        2,
                      ),
                      _divider(),
                      _menuTile(
                        Icons.diamond_sharp,
                        "My On Demand Order",
                        "Make your onw dish",
                        11,
                      ),
                    ]),

                    /// Account
                    _sectionTitle("Account"),

                    _menuCard([
                      _menuTile(
                        Icons.location_on_outlined,
                        "Saved Addresses",
                        "Manage delivery addresses",
                        3,
                      ),
                      /*_divider(),
                      _menuTile(
                        Icons.notifications_none,
                        "Notifications",
                        "Notification preferences",
                        4,
                      ),*/
                    ]),

                    /// Support
                    _sectionTitle("Contact Us"),

                    _menuCard([
                      _menuTile(
                        Icons.help_outline,
                        "Contact us & Help ",
                        "Contact customer support to vendor",
                        5,
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
                radius: 32,
                backgroundColor: Colors.green,
                child: TextSemi(str: chrName, color: AppColor.white, size: 25),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemi(str: profile?.name, size: 20),
                    TextRegular(str: profile?.phoneNumber, size: 14),
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
        if (type == 0) {
          AppUtils.launchScreen(context, MyOneOrderPage());
        } else if (type == 1) {
          AppUtils.launchScreen(context, MySubOrderPage());
        } else if (type == 2) {
          AppUtils.launchScreen(context, MySubscriptionPage());
        } else if (type == 3) {
          AppUtils.launchScreen(context, MyAddressPage());
        } else if (type == 5) {
          AppUtils.launchScreen(context, MyContactUsPage());
        } else if (type == 11) {
          AppUtils.launchScreen(context, UserDemandPageList());
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
