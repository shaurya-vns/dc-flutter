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

class DeliveryProfilePage extends StatefulWidget {
  const DeliveryProfilePage({super.key});

  @override
  State<DeliveryProfilePage> createState() => _DeliveryProfilePageState();
}

class _DeliveryProfilePageState extends State<DeliveryProfilePage> {
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
      title: 'Delivery Partner',
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
        if (type == 0) {
          //  AppUtils.launchScreen(context, MyOneOrderPage());
        }
      },
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }

  Widget _todayPerformanceCard() {
    const int assigned = 18;
    const int delivered = 12;
    const int pending = 5;
    const int cancelled = 1;

    final double progress = delivered / assigned;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Colors.green),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "Today's Performance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "66% Done",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _performanceItem(
                  title: "Assigned",
                  value: assigned.toString(),
                  icon: Icons.assignment,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _performanceItem(
                  title: "Delivered",
                  value: delivered.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _performanceItem(
                  title: "Pending",
                  value: pending.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _performanceItem(
                  title: "Cancelled",
                  value: cancelled.toString(),
                  icon: Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 18),

              const SizedBox(width: 6),

              Text(
                "$delivered of $assigned deliveries completed today",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _performanceItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _ratingAndEarningCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.workspace_premium, color: Colors.amber),

              SizedBox(width: 8),

              Text(
                "Performance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.star_rounded,
                  color: Colors.amber,
                  title: "Rating",
                  value: "4.9",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _infoCard(
                  icon: Icons.delivery_dining,
                  color: Colors.green,
                  title: "Deliveries",
                  value: "1,286",
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.currency_rupee,
                  color: Colors.deepPurple,
                  title: "Today's Earnings",
                  value: "₹640",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _infoCard(
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                  title: "Experience",
                  value: "2 Years",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _vehicleInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.two_wheeler, color: Colors.green),

              SizedBox(width: 8),

              Text(
                "Vehicle & Service Area",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _vehicleTile(
            icon: Icons.two_wheeler,
            title: "Vehicle",
            value: "Bike",
            color: Colors.orange,
          ),

          const SizedBox(height: 12),

          _vehicleTile(
            icon: Icons.badge,
            title: "Delivery ID",
            value: "DLV-1025",
            color: Colors.blue,
          ),

          const SizedBox(height: 12),

          _vehicleTile(
            icon: Icons.confirmation_number,
            title: "Vehicle Number",
            value: "UP16 AB 4589",
            color: Colors.deepPurple,
          ),

          const SizedBox(height: 12),

          _vehicleTile(
            icon: Icons.location_on,
            title: "Current Area",
            value: "Greater Noida West",
            color: Colors.red,
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 8, backgroundColor: Colors.green),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Available for Delivery",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickActionsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.grid_view_rounded, color: Colors.green),

              SizedBox(width: 8),

              Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _quickActionItem(
                  title: "Today's Orders",
                  icon: Icons.local_shipping_rounded,
                  color: Colors.blue,
                  onTap: () {
                    // Navigate
                  },
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _quickActionItem(
                  title: "History",
                  icon: Icons.history,
                  color: Colors.deepPurple,
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _quickActionItem(
                  title: "Earnings",
                  icon: Icons.account_balance_wallet,
                  color: Colors.orange,
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _quickActionItem(
                  title: "Profile",
                  icon: Icons.person,
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
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
