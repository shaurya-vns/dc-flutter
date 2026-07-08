import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/vendor/list/UserOrder.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../common_bloc.dart';

class UserDetailPage extends StatefulWidget {
  final UserOrder? user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getUserTodayOrderAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("User Detail"),
        backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_userInfoCard(), _addressCard(), _orderSection(), _actionButtons()],
        ),
      ),
    );
  }

  /// USER INFO
  Widget _userInfoCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColor.primaryColor.withOpacity(0.2),
            child: Text(
              widget.user?.name?.substring(0, 1).toUpperCase() ?? "U",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user?.name ?? "",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(widget.user?.phoneNumber ?? ""),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ADDRESS CARD
  Widget _addressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'user.address' ?? "No address available",
              style: const TextStyle(fontSize: 14),
            ),
          ),

          IconButton(
            onPressed: () {
              // open google map
            },
            icon: const Icon(Icons.map, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _orderSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today Orders",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          /// Subscription Order Card
          _orderTypeCard(
            title: "Subscription Orders",
            count: widget.user?.subscriptionOrderCount ?? 0,
            color: Colors.blue,
            icon: Icons.repeat,
            product: 'user?.subscriptionProductName',
            mealType: 'user?.subscriptionMealType',
            quantity: 2,
          ),

          const SizedBox(height: 12),

          /// One Time Order Card
          _orderTypeCard(
            title: "One Time Orders",
            count: widget.user?.oneTimeOrderCount ?? 0,
            color: Colors.orange,
            icon: Icons.fastfood,
            product: 'user?.oneTimeProductName',
            mealType: 'user?.oneTimeMealType',
            quantity: 2,
          ),
        ],
      ),
    );
  }

  Widget _orderTypeCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    String? product,
    String? mealType,
    int? quantity,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Product Info
          _infoRow("Product", product ?? "N/A"),
          _infoRow("Meal Type", mealType ?? "N/A"),
          _infoRow("Quantity", quantity?.toString() ?? "0"),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  /// ACTION BUTTONS
  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // mark as paid
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Mark as Paid"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // cancel order
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getUserTodayOrderAPI() {
    _commonBloc.getUserTodayOrderAPI(widget.user?.id);
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
        case ApiType.UPDATE_ONETIME_ORDER:
          {}
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
