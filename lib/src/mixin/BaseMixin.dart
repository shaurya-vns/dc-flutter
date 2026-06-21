import 'package:flutter/cupertino.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../widget/click_image.dart';
import '../widget/test_semi.dart';

mixin BaseMixin {
  Widget widgetBackUI(BuildContext context, String? title) {
    return Column(
      children: [
        Row(
          children: [
            Gap(w: 5),
            ClickImage(
              icon: DrawableConstant.ic_back,
              padding: 12,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(child: TextSemi(size: 18, str: title ?? '', color: AppColor.black)),
          ],
        ),
        CustomLine(),
      ],
    );
  }
}
