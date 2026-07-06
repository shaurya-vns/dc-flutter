import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../constants/color_constants.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../../widget/test_regular.dart';
import 'AddStationPage.dart';
import 'FirebaseServiceUtils.dart';
import 'model/get/StationModel.dart';

class StationListPage extends StatefulWidget {
  const StationListPage({super.key});

  @override
  State<StationListPage> createState() => _StationListPageState();
}

class _StationListPageState extends State<StationListPage> {
  List<StationModel> stationList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    getStation();
  }

  void getStation() {
    FirebaseServiceUtils.getStations(
      onSuccess: (stations) {
        setState(() {
          stationList = stations;
        });
      },
      onError: (error) {
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Station List',
      isBottom: false,
      onSwipe: () {
        getStation();
      },
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FillButtonWidget(
                  title: 'Add Station',
                  onPressed: () {
                    AppUtils.launchScreen(context, AddStationPage(isEdit: false));
                  },
                ),
              ),

              Gap(w: 10),
              FillButtonWidget(
                width: 120,
                bgColor: AppColor.colorBlue,
                title: 'Refresh',
                onPressed: () {
                  getStation();
                },
              ),
            ],
          ),
          Gap(h: 15),
          TextBold(
            str: 'Stations (${stationList.length})'.toUpperCase(),
            size: 14,
            color: AppColor.black,
          ),
          Gap(h: 7),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stationList.length,
            itemBuilder: (context, index) {
              final station = stationList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RoundedContainer(
                  padding: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: TextSemi(str: station.stationName)),
                          IconButton(
                            onPressed: () {
                              AppUtils.launchScreen(
                                context,
                                AddStationPage(isEdit: true, stationModel: station),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirebaseServiceUtils.deleteStation(
                                station.stationName,
                              );
                            },
                            icon: Icon(Icons.delete, color: AppColor.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextRegular(str: 'Gate ${station.gates.length}'),
                          ),
                          Expanded(
                            child: TextRegular(
                              str: 'Platform ${station.platforms.length}',
                            ),
                          ),
                          Expanded(
                            child: TextRegular(
                              str: 'Overbridge ${station.overbridges.length}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Gap(h: 100),
        ],
      ),
    );
  }

  final DatabaseReference ref = FirebaseDatabase.instance.ref("stations");

  Future<List<StationModel>> getStations() async {
    final snapshot = await ref.get();

    List<StationModel> stations = [];

    if (snapshot.exists) {
      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        stations.add(StationModel.fromJson(Map<dynamic, dynamic>.from(value)));
      });
    }

    return stations;
  }
}
