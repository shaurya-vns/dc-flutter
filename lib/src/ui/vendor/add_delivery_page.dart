import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../constants/fonts.dart';
import '../../model/base_error.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../widget/all_field_widget.dart';
import '../../widget/fill_button_widget.dart';
import '../../widget/rounded_container.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../auth/login/login_bloc.dart';

class AddDeliveryPage extends StatefulWidget {
  AddDeliveryPage();

  @override
  State<AddDeliveryPage> createState() => _AddDeliveryPageState();
}

class _AddDeliveryPageState extends State<AddDeliveryPage> {
  late LoginBloc _loginBloc;

  bool _showCheckBox = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final StreamController<String> _firstNameStream = BehaviorSubject();
  final StreamController<String> _mobileNumberStream = BehaviorSubject();
  final StreamController<String> _passwordStream = BehaviorSubject();
  final StreamController<String> _checkTerms = BehaviorSubject();

  FocusNode firstNameNode = FocusNode();
  FocusNode mobileNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      progressLoaderStream: _loginBloc.progressLoaderStream,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: AppColor.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CacheImage(
                        w: SCREEN_WIDTH,
                        h: 300,
                        url:
                            'https://dabbacorner.com/wp-content/uploads/al_opt_content/IMAGE/dabbacorner.com/wp-content/uploads/2025/12/04cd3ba6932c4c443a419c50af571f62.jpg.bv_resized_desktop.jpg.bv.webp?bv_host=dabbacorner.com',
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topLeft,
                            colors: [
                              AppColor.trans,
                              AppColor.colorBlue.withOpacity(0.8),
                              AppColor.colorBlue.withOpacity(1),
                            ],
                            stops: [0.0, 0.8, 1.0],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 55),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, size: 30, color: AppColor.white),
                        ),
                      ),
                    ],
                  ),
                  RoundedContainer(
                    padding: 20,
                    rounded: 30,
                    color: AppColor.color_bg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemi(
                          str: 'Create to delivery partner account',
                          color: AppColor.black,
                          size: 17,
                        ),
                        TextRegular(
                          str: 'Please enter partner detail to continue',
                          color: AppColor.black,
                          size: 13,
                        ),
                        const SizedBox(height: 15),
                        AllFieldWidget(
                          format: FORMAT.ALL,
                          controller: firstNameController,
                          field: 'Delivery Partner Name',
                          preNode: firstNameNode,
                          nextNode: mobileNode,
                          max: 50,
                          icon: Icons.supervised_user_circle_outlined,
                          onTypeChange: (String value) {
                            nameValid();
                          },
                        ),
                        AppUtils.widgetGetErrorUI(_firstNameStream),
                        AllFieldWidget(
                          format: FORMAT.PHONE,
                          controller: mobileController,
                          field: 'Delivery Partner Phone Number',
                          preNode: mobileNode,
                          nextNode: passwordNode,
                          max: 10,
                          icon: Icons.phone,
                          onTypeChange: (String value) {
                            phoneValidate();
                          },
                        ),
                        AppUtils.widgetGetErrorUI(_mobileNumberStream),
                        AllFieldWidget(
                          format: FORMAT.PASSWORD,
                          controller: passwordController,
                          field: 'Delivery Partner Password',
                          preNode: passwordNode,
                          nextNode: null,
                          icon: Icons.password,
                          max: 20,
                          isPassword: true,
                          onTypeChange: (String value) {
                            passwordValidate();
                          },
                        ),
                        AppUtils.widgetGetErrorUI(_passwordStream),
                        const SizedBox(height: 15),
                        FillButtonWidget(
                          height: 46,
                          fontSize: 14,
                          title: 'Create Delivery Partner Account',
                          onPressed: () {
                            signUpAPI();
                          },
                        ),
                        Gap(h: 25),
                        RoundedContainer(
                          padding: 10,
                          color: AppColor.color_156CD7.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info, color: AppColor.color_156CD7, size: 18),
                              Gap(w: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextSemi(str: 'Delivery Partners', size: 16),
                                    TextRegular(
                                      size: 14,
                                      str:
                                          'Delivery partner manage your order, subscriptions and on demand order',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        widgetTerms(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTerms() {
    return Center(
      child: InkWell(
        onTap: () {
          //AppUtils.launchScreen(context, WebPage());
        },
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "By logging or signing up, you agree to our ",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Fonts.REGULAR,
                  color: AppColor.black,
                ),
              ),
              TextSpan(
                text: "Terms & Policy",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  color: AppColor.black,
                  fontFamily: Fonts.MEDIUM,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.onDispose();
  }

  bool nameValid() {
    var str = firstNameController.text.trim();
    if (str.trim().isEmpty) {
      _firstNameStream.sink.add('Name is required');
      return false;
    } else if (str.trim().length < 2) {
      _firstNameStream.sink.add('Name must have more two characters');
      return false;
    }
    _firstNameStream.sink.add('');
    return true;
  }

  bool phoneValidate() {
    var str = mobileController.text.trim();
    if (str.isEmpty) {
      _mobileNumberStream.sink.add('Phone Number is required');
      return false;
    }
    _mobileNumberStream.sink.add('');
    return true;
  }

  bool passwordValidate() {
    var str = passwordController.text.trim();
    if (str.isEmpty) {
      _passwordStream.sink.add('Password is required');
      return false;
    } else if (str.length < 5) {
      _passwordStream.sink.add('Password must have 5 char more');
      return false;
    }
    _passwordStream.sink.add('');

    return true;
  }

  bool checkValid() {
    if (!_showCheckBox) {
      _checkTerms.sink.add('Please accept Terms of Use and Privacy Policy');
      return false;
    }
    _checkTerms.sink.add('');
    return true;
  }

  void signUpAPI() {
    AppUtils.isNetwork().then((value) {
      if (value) {
        String name = firstNameController.text.trim().toTitleCase();
        String mobileNumber = mobileController.text.trim().toLowerCase();
        String password = passwordController.text;

        bool isName = false;
        if (nameValid()) {
          isName = true;
        }

        bool isPhone = false;
        if (phoneValidate()) {
          isPhone = true;
        }

        bool isPassword = false;
        if (passwordValidate()) {
          isPassword = true;
        }

        if (isName && isPhone && isPassword) {
          AppUtils.hideKeyboard(context);
          _loginBloc.deliveryCreate(name, mobileNumber, password);
        }
      }
    });
  }

  void setObservables() {
    //success listener
    _loginBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.ADD_PARTNER:
          {
            var res = CommonResponse.fromJson(map);
            AppUtils.showToast(res.message);
            Navigator.pop(context);
          }
      }
    });

    //error listener
    _loginBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
