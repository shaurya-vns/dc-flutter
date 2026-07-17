import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/user/UserData.dart';
import '../../model/response/user/UserResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../utils/preference_util.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../auth/WelcomePage.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';
import 'AllPartnerListPage.dart';
import 'add_delivery_page.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
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
    return ScaffoldWidget(
      title: 'Vendor Profile',
      isBottom: false,
      onSwipe: () {
        getUserProfile();
      },
      child: SingleChildScrollView(child: Column(children: [_widgetUI()])),
    );
  }

  Widget _widgetUI() {
    return CommonStreamBuilder<UserData?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      nothing: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
        child: RoundedContainer(
          padding: 15,
          alignment: Alignment.center,
          child: Column(
            children: [
              TextSemi(
                size: 15,
                str: 'No One Time Orders Yet',
                color: AppColor.colorBlue,
              ),
              Gap(h: 10),
              TextRegular(
                align: 2,
                size: 13,
                color: AppColor.colorBlue,
                str:
                    'You don\'t have any orders for today.\nNew orders will appear here automatically.',
              ),
            ],
          ),
        ),
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _deliveryHeaderCard(data),
            Gap(h: 5),
            _sectionTitle("Account"),
            _menuCard([
              _menuTile(
                Icons.location_on_outlined,
                "Saved Addresses",
                "Manage delivery addresses",
                1,
              ),
            ]),
            Gap(h: 14),
            _sectionTitle("Delivery Partners"),
            _menuCard([
              _menuTile(
                Icons.bike_scooter,
                "Add Delivery Partner",
                "Add your delivery partners",
                2,
              ),
              _divider(),
              _menuTile(
                Icons.manage_accounts,
                "Manage Delivery Partner",
                "Manage your delivery partners",
                3,
              ),
            ]),

            Gap(h: 14),
            _sectionTitle("Contact Us"),
            _menuCard([
              _menuTile(
                Icons.help_outline,
                "Contact us & Help ",
                "Contact customer support to vendor",
                3,
              ),
            ]),
            Gap(h: 14),
            _sectionTitle("Legal"),
            _menuCard([
              _menuTile(Icons.privacy_tip_outlined, "Privacy Policy", "", 6),
              _divider(),
              _menuTile(Icons.description_outlined, "Terms & Conditions", "", 7),
              _divider(),
              _menuTile(Icons.info_outline, "About Us", "", 8),
            ]),
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _deliveryHeaderCard(UserData? data) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff22C55E), Color(0xff16A34A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delivery_dining, color: Colors.white, size: 24),
              ),

              const SizedBox(width: 12),

              Expanded(child: TextBold(str: data?.name, color: AppColor.white, size: 17)),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.greenAccent),

                    SizedBox(width: 6),

                    Text(
                      "Online",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Profile
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      AppUtils.getFirstValue(USER_DATA?.name),
                      style: const TextStyle(
                        color: Color(0xff22C55E),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data?.name ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            data?.phoneNumber ?? "",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "🚴 Active Partner",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
        if (type == 2) {
          AppUtils.launchScreen(context, AddDeliveryPage());
        } else if (type == 3) {
          AppUtils.launchScreen(context, AllPartnerListPage());
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
