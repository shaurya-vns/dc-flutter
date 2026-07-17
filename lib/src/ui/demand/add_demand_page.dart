import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/sheet/AddressBottomSheet.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../model/base_error.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_utils.dart';
import '../../utils/date_picker_utils.dart';
import '../../utils/gap.dart';
import '../../utils/time_utils.dart';
import '../common_bloc.dart';

class AddDemandPage extends StatefulWidget {
  const AddDemandPage({Key? key}) : super(key: key);

  @override
  State<AddDemandPage> createState() => _AddDemandPageState();
}

class _AddDemandPageState extends State<AddDemandPage> with BaseMixin {
  final TextEditingController foodController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  int quantity = 1;

  DateTime selectedDate = DateTime.now();

  String selectedMeal = "breakfast";

  String? startDateUI;
  String? startDateAPI;

  late CommonBloc _commonBloc;

  String? homeAddress1;
  String? fullAddress1;
  int? addressId1;

  @override
  void initState() {
    var now = DateTime.now().add(Duration(days: 0));
    startDateUI = TimeUtils.parseDateTime(now);
    startDateAPI = TimeUtils.parseDateApi(now);
    homeAddress1 = homeAddress;
    fullAddress1 = fullAddress;
    addressId1 = addressId1;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      progressLoaderStream: _commonBloc.progressLoaderStream,
      child: ScaffoldWidget(
        title: 'Request On Demand Order',
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              _foodCard(),
              _quantityCard(),
              _deliveryDateCard(),
              _mealTypeCard(),
              _addressCard(),
              _budgetCard(),
              _noteCard(),
              _infoCard(),
              const SizedBox(height: 120),
            ],
          ),
        ),
        bottom: _widgetBottomUI(),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // FOOD CARD
  //----------------------------------------------------------------------------

  Widget _foodCard() {
    return Card(
      elevation: 0,
      color: const Color(0xffFFF4EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.restaurant_menu, color: Color(0xffFF6B35), size: 20),
                SizedBox(width: 10),
                Text(
                  "What would you like to eat?",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 10),
            TextField(
              controller: foodController,
              decoration: InputDecoration(
                hintText: "Food Name: Paneer Paratha, Sandwich, Pasta, Rajma Chawal...",
                filled: true,
                hintStyle: TextStyle(fontSize: 15),
                hintMaxLines: 4,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.fastfood, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Describe your meal exactly how you want it.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // QUANTITY CARD
  //----------------------------------------------------------------------------

  Widget _quantityCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: const Text(
                "Quantity",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),

            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffFFF4EC),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ),

                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // DELIVERY DATE CARD
  //----------------------------------------------------------------------------

  Widget _deliveryDateCard() {
    return CustomCard(
      color: AppColor.white,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: const Color(0xffFFF4EC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.calendar_month, color: Color(0xffFF6B35)),
        ),

        title: const Text("Delivery Date", style: TextStyle(fontWeight: FontWeight.w600)),

        subtitle: TextRegular(str: startDateUI),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: _selectDate,
      ),
    );
  }

  Widget _mealTypeCard() {
    final meals = [
      {"title": "breakfast", "icon": Icons.free_breakfast},
      {"title": "lunch", "icon": Icons.lunch_dining},
      {"title": "dinner", "icon": Icons.dinner_dining},
    ];

    return CustomCard(
      child: Container(
        width: SCREEN_WIDTH,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Meal Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 1),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    meals.map((meal) {
                      final bool selected = selectedMeal == meal["title"];
                      return ChoiceChip(
                        avatar: Icon(
                          meal["icon"] as IconData,
                          size: 18,
                          color: selected ? Colors.white : Colors.orange,
                        ),
                        label: Text(AppUtils.formatStatus(meal["title"].toString())),
                        selected: selected,
                        selectedColor: AppColor.colorBlue,
                        backgroundColor: Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedMeal = meal["title"] as String;
                          });
                        },
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Gap(h: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF4EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on, color: Color(0xffFF6B35)),
                ),
                Gap(w: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeAddress1 ?? 'Select Delivery address',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(fullAddress1 ?? ''),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showAddressSheet();
                  },
                  child: const Text("Change"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Amount",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "250",
                prefixIcon: const Icon(Icons.currency_rupee),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Additional Instructions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "No Onion\nLess Spicy\nExtra Cheese",

                filled: true,
                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Color(0xffFF6B35)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Vendor Review", style: TextStyle(fontWeight: FontWeight.bold)),

                  SizedBox(height: 6),

                  Text(
                    "• Vendor will review your custom meal request.\n\n"
                    "• Final price may be different from your expected budget.\n\n"
                    "• You'll receive a notification once the vendor accepts or rejects your request.",
                    style: TextStyle(height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DatePickerUtils.selectCalendarOnly(
      context: context,

      onDateCallback: (uiDate, apiDate) {
        print('SSSS uiDate $uiDate');
        startDateUI = uiDate;
        startDateAPI = apiDate;
        print('SSSS apiDate $apiDate');
        setState(() {});
      },
    );
  }

  void showAddressSheet() {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddressBottomSheet(
          onCallback: (AddressModel? add) {
            homeAddress1 = add?.addressTypeLabel;
            fullAddress1 = add?.fullAddress;
            addressId = add?.id;
            setState(() {});
          },
        );
      },
    );
  }

  Widget _widgetBottomUI() {
    return Container(
      padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: SafeArea(
        child: FillButtonWidget(
          title: 'On Demand Order Request',
          onPressed: () {
            addAPI();
          },
        ),
      ),
    );
  }

  void addAPI() {
    bool isOK = true;
    String? itemName = foodController.text.trim();
    int? address = addressId;
    String? userAmount = budgetController.text.trim();
    String? deliveryDate = startDateAPI;
    String? mealType = selectedMeal;
    String? note = noteController.text.trim();

    if (AppUtils.isBlank(itemName)) {
      AppUtils.showToast('Food name is required');
      isOK = false;
    }
    if (addressId == null) {
      AppUtils.showToast('Delivery address is required');
      isOK = false;
    }
    if (AppUtils.isBlank(userAmount)) {
      AppUtils.showToast('User amount is required');
      isOK = false;
    }

    if (isOK) {
      _commonBloc.createOnDemandOrderAPI(
        address,
        itemName,
        quantity,
        deliveryDate,
        mealType,
        userAmount,
        note,
      );
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
        case ApiType.CREATE_ON_DEMAND_ORDER:
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
