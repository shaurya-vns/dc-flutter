import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/coach/model/add/PlatformModel.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/widget/all_field_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/color_constants.dart';
import '../../utils/gap.dart';
import '../../widget/fix_button_widget.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import 'coach_field_widget.dart';
import 'model/get/StationModel.dart';

class AddStationPage extends StatefulWidget {
  final bool isEdit;
  final StationModel? stationModel;

  const AddStationPage({super.key, this.stationModel, required this.isEdit});

  @override
  State<AddStationPage> createState() => _AddStationPageState();
}

class _AddStationPageState extends State<AddStationPage> {
  TextEditingController nameController = TextEditingController();
  FocusNode nameNode = FocusNode();
  StationModel? stationModel;

  List<PlatformModel> gates = [];
  List<PlatformModel> platform = [];
  List<PlatformModel> overbridge = [];

  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    stationModel = widget.stationModel;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setData();
  }

  void setData() {
    nameController.text = stationModel?.stationName ?? '';

    stationModel?.gates.forEach((action) {
      PlatformModel m = PlatformModel();
      m.nameController.text = action.name;
      m.latitudeController.text = '${action.latitude}';
      m.longitudeController.text = '${action.longitude}';
      gates.add(m);
    });

    stationModel?.platforms.forEach((action) {
      PlatformModel m = PlatformModel();
      m.nameController.text = action.name;
      m.latitudeController.text = '${action.latitude}';
      m.longitudeController.text = '${action.longitude}';
      platform.add(m);
    });

    stationModel?.overbridges.forEach((action) {
      PlatformModel m = PlatformModel();
      m.nameController.text = action.name;
      m.latitudeController.text = '${action.latitude}';
      m.longitudeController.text = '${action.longitude}';
      overbridge.add(m);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: widget.isEdit ? 'Edit Station' : 'Add Station',
      isBottom: false,
      bottom: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: FillButtonWidget(
          title: 'Add',
          onPressed: () {
            addData();
          },
        ),
      ),
      onSwipe: () {},
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              CoachFieldWidget(
                format: FORMAT1.ALL,
                controller: nameController,
                field: 'Enter Station Name',
                preNode: nameNode,
                nextNode: null,
                max: 50,
                icon: Icons.train,
                onTypeChange: (String value) {},
              ),
              Gap(h: 20),
              _widgetTab(),
              Gap(h: 20),
              _widgetTypeTabUI(),
              Gap(h: 20),
              _widgetValueUI(),
              Gap(h: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _widgetItem('Gate', 1),
          _widgetItem('Platform', 2),
          _widgetItem('Overbridge', 3),
        ],
      ),
    );
  }

  int _selectedTab = 1;

  Widget _widgetItem(String str, int type) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: FixButtonWidget(
        color: _selectedTab == type ? AppColor.colorBlue : AppColor.white,
        borderColor: AppColor.colorBlue.withOpacity(0.3),
        height: 36,
        child: Row(
          children: [
            Gap(w: 12),
            Icon(
              Icons.all_inbox,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 15,
            ),
            Gap(w: 6),
            TextRegular(
              str: str,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 17,
            ),
            Gap(w: 15),
          ],
        ),
        onPressed: () {
          _selectedTab = type;
          setState(() {});
        },
      ),
    );
  }

  Widget _widgetTypeTabUI() {
    if (_selectedTab == 1) {
      return _widgetGate();
    } else if (_selectedTab == 2) {
      return _widgetPlatform();
    } else {
      return _widgetOver();
    }
  }

  Widget _widgetGate() {
    return Column(
      children: [
        FillButtonWidget(
          bgColor: AppColor.colorBlue,
          width: 190,
          fontSize: 14,
          height: 40,
          title: 'Add Gate',
          onPressed: () {
            PlatformModel p1 = PlatformModel();
            gates.add(p1);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _widgetPlatform() {
    return Column(
      children: [
        FillButtonWidget(
          bgColor: AppColor.colorBlue,
          width: 190,
          fontSize: 14,
          height: 40,
          title: 'Add Platform',
          onPressed: () {
            PlatformModel p1 = PlatformModel();
            platform.add(p1);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _widgetOver() {
    return Column(
      children: [
        FillButtonWidget(
          bgColor: AppColor.colorBlue,
          width: 190,
          fontSize: 14,
          height: 40,
          title: 'Add Overbridge',
          onPressed: () {
            PlatformModel p1 = PlatformModel();
            overbridge.add(p1);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _widgetValueUI() {
    List<PlatformModel> data = [];
    String name = '';
    if (_selectedTab == 1) {
      name = 'Gate ';
      data = gates;
    } else if (_selectedTab == 2) {
      name = 'Platform ';
      data = platform;
    } else {
      name = 'Overbridge ';
      data = overbridge;
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: AppUtils.getLength(data.length),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var value = data[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RoundedContainer(
            padding: 10,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CoachFieldWidget(
                        format: FORMAT.ALL,
                        controller: value.nameController,
                        field: 'Enter gate name',
                        preNode: null,
                        nextNode: null,

                        max: 50,
                        onTypeChange: (String value) {},
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        data.remove(value);
                        setState(() {});
                      },
                      icon: Icon(color: AppColor.red, Icons.delete),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: CoachFieldWidget(
                        format: FORMAT1.LAT,
                        controller: value.latitudeController,
                        field: 'Latitude',
                        preNode: null,
                        nextNode: null,

                        max: 10,
                        onTypeChange: (String value) {},
                      ),
                    ),
                    Gap(w: 10),
                    Expanded(
                      child: CoachFieldWidget(
                        format: FORMAT1.LAT,
                        controller: value.longitudeController,
                        field: 'Longitude',
                        preNode: null,
                        nextNode: null,

                        max: 10,
                        onTypeChange: (String value) {},
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        getCurrentLocation(value);
                      },
                      icon: Icon(Icons.location_on_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addData() {
    bool isOk = true;
    var name = nameController.text.trim();
    if (AppUtils.isBlank(name)) {
      AppUtils.showToast('Station name is required');
      isOk = false;
      return;
    }
    gates.forEach((action) {
      if (AppUtils.isBlank(action.nameController.text.trim())) {
        AppUtils.showToast('Gate name is required');
        isOk = false;
        return;
      }
    });
    platform.forEach((action) {
      if (AppUtils.isBlank(action.nameController.text.trim())) {
        AppUtils.showToast('Platform name is required');
        isOk = false;
        return;
      }
    });
    overbridge.forEach((action) {
      if (AppUtils.isBlank(action.nameController.text.trim())) {
        AppUtils.showToast('Overbridge name is required');
        isOk = false;
        return;
      }
    });

    if (isOk) {
      if (widget.isEdit) {
        updateStation();
      } else {
        saveStation();
      }
    }
  }

  Future<void> updateStation() async {
    final ref = FirebaseDatabase.instance.ref("stations");
    final stationName = nameController.text.trim();
    await ref.child(stationName).update({
      "stationName": stationName,
      "gates": gates.map((e) => e.toJson()).toList(),
      "platform": platform.map((e) => e.toJson()).toList(),
      "overbridge": overbridge.map((e) => e.toJson()).toList(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Station updated Successfully")));

    Navigator.pop(context);
  }

  Future<void> saveStation() async {
    final ref = FirebaseDatabase.instance.ref("stations");
    final stationName = nameController.text.trim();
    await ref.child(stationName).set({
      "stationName": stationName,
      "gates": gates.map((e) => e.toJson()).toList(),
      "platform": platform.map((e) => e.toJson()).toList(),
      "overbridge": overbridge.map((e) => e.toJson()).toList(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Station Added Successfully")));

    Navigator.pop(context);
  }

  Future<void> getCurrentLocation(PlatformModel value) async {
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

      value.latitudeController.text = '$latitude';
      value.longitudeController.text = '$longitude';
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
