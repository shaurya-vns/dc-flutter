import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/contact/AddContactPage.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/test_light.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/contact/ContactUsData.dart';
import '../../model/response/contact/ContactUsResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../utils/widgetUtils.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/custome_card.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';

class MyContactUsPage extends StatefulWidget {
  const MyContactUsPage({super.key});

  @override
  State<MyContactUsPage> createState() => _MyContactUsPageState();
}

class _MyContactUsPageState extends State<MyContactUsPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<ContactUsData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getContactUsList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My Contact Us',
      isBottom: false,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: FillButtonWidget(
              title: 'Add New Contact',
              onPressed: () async {
                await AppUtils.launchScreenWithResult(context, AddContactPage());
                getContactUsList();
              },
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<ContactUsData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      nothing: WidgetUtils.noOrderWidget(
        title: "No contact yet",
        message: "Make your contact to vendor for best way.",
        onRefresh: () {
          getContactUsList();
        },
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Contact (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetUI(today, data?.length);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _widgetUI(ContactUsData? contact, int? length) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            AddContactPage(contact: contact),
          );
          getContactUsList();
        },
        child: CustomCard(
          rounded: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(
                        str: contact?.name,
                        max: 1,
                        color: AppColor.black,
                        size: 15,
                      ),
                      TextSemi(
                        str: contact?.phoneNumber,
                        max: 10,
                        color: AppColor.black,
                        size: 13,
                      ),
                      Gap(h: 5),
                      TextRegular(str: 'Subject:', size: 13),
                      TextRegular(
                        str: contact?.subject,
                        max: 10,
                        color: AppColor.colorBlue,
                        size: 13,
                      ),
                      Gap(h: 3),
                      TextRegular(str: 'Message:', size: 13),
                      TextLight(str: contact?.message, color: AppColor.black, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getContactUsList() {
    _commonBloc.getContactUsList();
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
        case ApiType.CONTACT_US_LIST:
          {
            var res = ContactUsResponse.fromJson(map);
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
