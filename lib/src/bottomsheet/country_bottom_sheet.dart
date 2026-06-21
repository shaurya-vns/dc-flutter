import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../countrypicker/CountryList.dart';
import '../../countrypicker/CountryModel.dart';
import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../utils/log.dart';
import '../widget/search_widget.dart';

class CountryBottomSheet extends StatefulWidget {
  final Function(CountryModel? value) onItemClick;

  CountryBottomSheet({required this.onItemClick});

  @override
  _CountryBottomSheetState createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {
  final StreamController<List<CountryModel>> _countryStream = BehaviorSubject();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _countryStream.sink.add(COUNTRIES);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: AppColor.white,
        height: MediaQuery.of(context).size.height - 120,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchWidget(
                          autoSearch: true,
                          preNode: null,
                          textInputAction: TextInputAction.done,
                          controller: searchController,
                          hint: 'Search country name...',
                          onTypeChange: (value) {
                            List<CountryModel> dd = [];
                            COUNTRIES.forEach((element) {
                              if (element.name.startsWith(value)) {
                                dd.add(element);
                              }
                            });
                            _countryStream.sink.add(dd);
                          },
                        ),
                      ),
                      const SizedBox(width: 3),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(11),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Image.asset(
                            DrawableConstant.ic_cross,
                            width: 30,
                            height: 30,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: StreamBuilder<List<CountryModel>>(
                      stream: _countryStream.stream,
                      builder: (context, snapshot) {
                        Log.i('snapshot ${COUNTRIES[0].name}');
                        if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
                          var countryList = snapshot.data;

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: countryList?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var cc = countryList?[index];
                              var flag =
                                  'assets/flags/flag_${cc?.code.toLowerCase()}.png';
                              return InkWell(
                                onTap: () {
                                  cc?.flag = flag;
                                  widget.onItemClick(cc);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Image.asset(flag, width: 25, height: 23),
                                      SizedBox(width: 4),
                                      Text(
                                        cc?.dialCode ?? '',
                                        style: TextStyle(
                                          color: AppColor.color_D25B17,
                                          fontSize: 14,
                                          fontFamily: Fonts.SEMI_BOLD,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.clip,
                                          cc?.name ?? '',
                                          style: const TextStyle(
                                            color: AppColor.black,
                                            fontSize: 13,
                                            fontFamily: Fonts.MEDIUM,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container(
                          height: 140,
                          alignment: Alignment.center,
                          child: const Text(
                            'No country found',
                            style: TextStyle(
                              color: AppColor.color_D25B17,
                              fontSize: 15,
                              fontFamily: Fonts.MEDIUM,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
