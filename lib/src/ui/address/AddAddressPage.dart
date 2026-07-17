import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../model/base_error.dart';
import '../../model/response/address/AddressModel.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../widget/scaffold_widget.dart';
import '../common_bloc.dart';

class AddAddressPage extends StatefulWidget {
  final AddressModel? address;

  const AddAddressPage({super.key, this.address});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final houseNoController = TextEditingController();
  final landmarkController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final phoneController = TextEditingController();

  int addressType = 1;
  bool isDefault = true;

  late CommonBloc _commonBloc;
  AddressModel? address;

  @override
  void initState() {
    address = widget.address;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    setData();
  }

  void setData() {
    if (address != null) {
      houseNoController.text = address?.houseNo ?? '';
      landmarkController.text = address?.landmark ?? '';
      addressController.text = address?.address ?? '';
      cityController.text = address?.city ?? '';
      stateController.text = address?.state ?? '';
      pinCodeController.text = '${address?.pincode}';
      latitude = address?.latitude ?? 0.0;
      longitude = address?.longitude ?? 0.0;
      addressType = address?.addressType ?? 1;
      phoneController.text = address?.phoneNumber ?? '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: "Add Address",
      isBottom: false,
      bottom: _widgetBottom(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Address Type
              const Text(
                "Address Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _typeChip("Home", 1, Icons.home),
                  const SizedBox(width: 10),
                  _typeChip("Office", 2, Icons.business),
                  const SizedBox(width: 10),
                  _typeChip("Other", 3, Icons.location_on),
                ],
              ),

              const SizedBox(height: 20),

              _textField(
                controller: houseNoController,
                label: "House / Flat No.",
                icon: Icons.home_work_outlined,
              ),

              const SizedBox(height: 16),

              _textField(
                controller: landmarkController,
                label: "Landmark",
                icon: Icons.location_city_outlined,
              ),

              const SizedBox(height: 16),

              _textField(
                controller: addressController,
                label: "Full Address",
                icon: Icons.location_on_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _textField(
                      controller: cityController,
                      label: "City",
                      icon: Icons.location_city,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _textField(
                      controller: stateController,
                      label: "State",
                      icon: Icons.map,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _textField(
                controller: pinCodeController,
                label: "Pincode",
                keyboardType: TextInputType.number,
                icon: Icons.pin_drop_outlined,
              ),

              const SizedBox(height: 20),
              _textField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                label: "Phone number",
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                value: isDefault,
                contentPadding: EdgeInsets.zero,
                title: const Text("Set as Default Address"),
                onChanged: (value) {
                  setState(() {
                    isDefault = value;
                  });
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String title, int value, IconData icon) {
    final selected = addressType == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            addressType = value;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: selected ? Colors.green : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? Colors.green : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.black54),

              const SizedBox(width: 6),

              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _widgetBottom() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loadingLocation ? null : getCurrentLocation,
              icon:
                  loadingLocation
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.my_location),
              label: Text(
                loadingLocation ? "Fetching Location..." : "Use Current Location",
              ),
            ),
          ),
          Gap(h: 10),
          FillButtonWidget(
            title: 'Save Address',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Map<String, dynamic> body = {
                  "addressType": addressType,
                  "houseNo": houseNoController.text,
                  "landmark": landmarkController.text,
                  "address": addressController.text,
                  "city": cityController.text,
                  "state": stateController.text,
                  "pincode": pinCodeController.text,
                  "isDefault": isDefault,
                  "latitude": latitude,
                  "longitude": longitude,
                  "phoneNumber": phoneController.text,
                };
                addAddressAPI(body);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  double? latitude;
  double? longitude;
  bool loadingLocation = false;

  Future<void> getCurrentLocation() async {
    setState(() {
      loadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please enable location service")));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Location permission denied")));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);

      Placemark place = placemarks.first;

      houseNoController.text = place.subThoroughfare ?? "";

      addressController.text = "${place.street ?? ""}, ${place.subLocality ?? ""}";

      landmarkController.text = place.name ?? "";

      cityController.text = place.locality ?? "";

      stateController.text = place.administrativeArea ?? "";

      pinCodeController.text = place.postalCode ?? "";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      loadingLocation = false;
    });
  }

  Future<void> addAddressAPI(Map<String, dynamic> body) async {
    bool valid = await validateAddress();

    if (!valid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a valid address.")));
      return;
    }
    if (widget.address != null) {
      _commonBloc.updateAddressAPI(widget.address?.id, body);
    } else {
      _commonBloc.addAddressAPI(body);
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
        case ApiType.ADDRESS_ADD:
        case ApiType.ADDRESS_UPDATE:
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

  Future<bool> validateAddress() async {
    try {
      final fullAddress =
          "${houseNoController.text}, "
          "${addressController.text}, "
          "${cityController.text}, "
          "${stateController.text}, "
          "${pinCodeController.text}";

      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isEmpty) {
        return false;
      }

      final location = locations.first;

      latitude = location.latitude;
      longitude = location.longitude;

      return true;
    } catch (e) {
      return false;
    }
  }
}
