import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/custome_line.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_bold.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late CommonBloc _commonBloc;

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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(15),
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
                          const CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.green,
                            child: Text(
                              "SK",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Shaurya Kumar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "+91 9876543210",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "shaurya@gmail.com",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Orders
                    _sectionTitle("Orders"),

                    _menuCard([
                      _menuTile(
                        Icons.shopping_bag_outlined,
                        "My Orders",
                        "View your one-time orders",
                      ),
                      _divider(),
                      _menuTile(
                        Icons.repeat,
                        "My Subscriptions",
                        "Manage active subscriptions",
                      ),
                      _divider(),
                      _menuTile(Icons.favorite_border, "Wishlist", "Saved meals"),
                    ]),

                    /// Account
                    _sectionTitle("Account"),

                    _menuCard([
                      _menuTile(
                        Icons.location_on_outlined,
                        "Saved Addresses",
                        "Manage delivery addresses",
                      ),
                      _divider(),
                      _menuTile(Icons.payment, "Payment Methods", "Cards & UPI"),
                      _divider(),
                      _menuTile(
                        Icons.notifications_none,
                        "Notifications",
                        "Notification preferences",
                      ),
                    ]),

                    /// Support
                    _sectionTitle("Support"),

                    _menuCard([
                      _menuTile(
                        Icons.help_outline,
                        "Help & Support",
                        "Contact customer support",
                      ),
                      _divider(),
                      _menuTile(
                        Icons.chat_outlined,
                        "Chat with Vendor",
                        "Need help with an order?",
                      ),
                      _divider(),
                      _menuTile(Icons.star_border, "Rate App", "Share your feedback"),
                    ]),

                    /// Legal
                    _sectionTitle("Legal"),

                    _menuCard([
                      _menuTile(Icons.privacy_tip_outlined, "Privacy Policy", ""),
                      _divider(),
                      _menuTile(Icons.description_outlined, "Terms & Conditions", ""),
                      _divider(),
                      _menuTile(Icons.policy_outlined, "Refund Policy", ""),
                      _divider(),
                      _menuTile(Icons.info_outline, "About Us", ""),
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
                        onPressed: () {},
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

  Widget _menuTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.green.shade50,
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: () {},
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {}
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
