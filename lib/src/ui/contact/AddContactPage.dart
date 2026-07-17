import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/message_field_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/base_error.dart';
import '../../model/response/contact/ContactUsData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/gap.dart';
import '../../utils/widgetUtils.dart';
import '../../widget/all_field_widget.dart';
import '../../widget/scaffold_widget.dart';
import '../common_bloc.dart';

class AddContactPage extends StatefulWidget {
  final ContactUsData? contact;

  const AddContactPage({super.key, this.contact});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  late CommonBloc _commonBloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode subjectNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode messagedNode = FocusNode();
  ContactUsData? contact;

  @override
  void initState() {
    contact = widget.contact;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    setData();
  }

  void setData() {
    nameController.text = contact?.name ?? '';
    subjectController.text = contact?.subject ?? '';
    phoneController.text = contact?.phoneNumber ?? '';
    messageController.text = contact?.message ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      progressLoaderStream: _commonBloc.progressLoaderStream,
      child: ScaffoldWidget(
        title: "Contact Us",
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(h: 10),
              WidgetUtils.getFieldValue('Name', isStart: true),
              AllFieldWidget(
                format: FORMAT.ALL,
                controller: nameController,
                field: 'Enter your name',
                preNode: nameNode,
                nextNode: subjectNode,
                icon: Icons.supervised_user_circle_outlined,
                max: 50,
                onTypeChange: (String value) {},
              ),
              Gap(h: 20),
              WidgetUtils.getFieldValue('Subject', isStart: true),
              AllFieldWidget(
                format: FORMAT.ALL,
                controller: subjectController,
                field: 'Enter your subject',
                preNode: subjectNode,
                nextNode: phoneNode,
                icon: Icons.subject,
                max: 100,
                onTypeChange: (String value) {},
              ),
              Gap(h: 20),
              WidgetUtils.getFieldValue('Phone Number', isStart: true),
              AllFieldWidget(
                format: FORMAT.PHONE,
                controller: phoneController,
                field: 'Enter Phone Number',
                preNode: phoneNode,
                nextNode: messagedNode,
                max: 10,
                icon: Icons.phone,
                onTypeChange: (String value) {},
              ),
              const SizedBox(height: 20),
              WidgetUtils.getFieldValue('Description', isStart: true),
              MessageFieldWidget(
                maxLines: 4,
                maxLength: 500,
                preNode: messagedNode,
                controller: messageController,
                onTypeChange: (String value) {},
                hint: 'Enter description...',
              ),

              if (AppUtils.isNotBlank(contact?.adminRemark)) ...[
                const SizedBox(height: 20),
                TextSemi(str: 'Admin Remarks', size: 15, color: AppColor.colorBlue),
                const SizedBox(height: 5),
                RoundedContainer(
                  alignment: Alignment.topLeft,
                  padding: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextRegular(
                        str: contact?.adminRemark,
                        color: AppColor.black,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),
              FillButtonWidget(
                title: 'Submit',
                onPressed: () {
                  submit();
                },
              ),
              Gap(h: 60),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    var name = nameController.text.trim();
    if (name.isEmpty) {
      AppUtils.showToast("Name is required");
      return;
    }

    var subject = subjectController.text.trim();
    if (subject.isEmpty) {
      AppUtils.showToast("Subject is required");
      return;
    }

    var phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      AppUtils.showToast("Phone number is required.");
      return;
    }

    var message = messageController.text.trim();
    if (message.isEmpty) {
      AppUtils.showToast("Description is required");
      return;
    }

    _commonBloc.createContactUsAPI(name, subject, phoneNumber, message);
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
        case ApiType.CREATE_CONTACT_US:
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
