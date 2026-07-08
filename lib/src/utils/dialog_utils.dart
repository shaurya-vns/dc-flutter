import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts.dart';
import '../widget/fill_button_widget.dart';
import '../widget/message_field_widget.dart';
import '../widget/test_regular.dart';
import 'app_utils.dart';
import 'gap.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  void showCustomDialog(
    BuildContext context, {
    required String title,
    String okBtnText = "Ok",
    String cancelBtnText = "Cancel",
    required Function okBtnFunction,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text('fejoiwejoiwejr we'),
          actions: <Widget>[
            TextButton(child: Text(okBtnText), onPressed: () {}),
            TextButton(
              child: Text(cancelBtnText),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void widgetDialog({
    required BuildContext context,
    required String? title,
    required String? msg,
    required String? no,
    required String? yes,
    required Function(bool yes) callback,
  }) {
    var dialog = Dialog(
      backgroundColor: AppColor.white,
      surfaceTintColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), //this right here
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: Fonts.SEMI_BOLD,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              msg ?? '',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: Fonts.REGULAR,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback(false);
                  },
                  child: Text(
                    no ?? '',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 17.0,
                      fontFamily: Fonts.SEMI_BOLD,
                    ),
                  ),
                ),
                SizedBox(width: 3),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback(true);
                  },
                  child: Text(
                    yes ?? '',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 17.0,
                      fontFamily: Fonts.SEMI_BOLD,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void widgetCancelUserOnDemandDialog({
    required BuildContext context,
    required Function(String reason) callback,
  }) {
    TextEditingController commentController = TextEditingController();
    var dialog = Dialog(
      backgroundColor: AppColor.color_bg,
      surfaceTintColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), //this right here
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Gap(h: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextRegular(str: 'Reason', color: AppColor.color_0E1E2E, size: 16),
                Gap(h: 4),
                MessageFieldWidget(
                  maxLines: 4,
                  maxLength: 500,
                  preNode: null,
                  controller: commentController,
                  onTypeChange: (String value) {},
                  hint: 'Enter cancel reason...',
                ),
              ],
            ),

            Gap(h: 20),
            FillButtonWidget(
              radius: 10,
              fontSize: 15,
              title: 'Cancel',
              onPressed: () {
                if (AppUtils.isNotBlank(commentController.text.trim())) {
                  callback(commentController.text.trim());
                } else {
                  AppUtils.showToast('Please enter cancel reason');
                }
              },
            ),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
