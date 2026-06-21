import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/custome_line.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import 'menu_widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: SingleChildScrollView(child: MenuWidget()),
            ),
            Column(
              children: [
                Gap(h: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _widgetHeader(),
                ),
                Gap(h: 10),
                CustomLine(),
                Gap(h: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetHeader() {
    return Row(
      children: [
        Expanded(child: TextSemi(str: 'Our Menu', size: 20, color: AppColor.black)),
        RoundedContainer(w: 35, h: 35, color: AppColor.color_B0B0B0, rounded: 40),
      ],
    );
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {}
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
