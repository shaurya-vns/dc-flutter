import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/ui/auth/signup/sign_up_page.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';
import 'package:flutter_dc/src/ui/vendor/dashboard/vendor_home_page.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/all_field_widget.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/borderline_button_widget.dart';
import 'package:flutter_dc/src/widget/click_text.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/fonts.dart';
import '../../../constants/size_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/user/UserResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/preference_util.dart';
import '../../../widget/fill_button_widget.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  final int userType;

  const LoginPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode mobileNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final StreamController<String> _phoneStream = BehaviorSubject();
  final StreamController<String> _passwordStream = BehaviorSubject();

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
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
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
                      Image.asset(
                        DrawableConstant.ic_test_1,
                        width: SCREEN_WIDTH,
                        fit: BoxFit.fitWidth,
                        height: 290,
                      ),
                      Container(
                        height: 290,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topLeft,
                            colors: [
                              AppColor.trans,
                              AppColor.black.withOpacity(0.8),
                              AppColor.black.withOpacity(1),
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
                          str: 'Login to your account',
                          color: AppColor.black,
                          size: 19,
                        ),
                        TextRegular(
                          str: 'Please enter your detail to continue',
                          color: AppColor.black,
                          size: 15,
                        ),
                        const SizedBox(height: 10),
                        AllFieldWidget(
                          format: FORMAT.PHONE,
                          controller: mobileController,
                          field: 'Phone Number*',
                          preNode: mobileNode,
                          nextNode: passwordNode,
                          max: 10,
                          icon: Icons.phone,
                          onTypeChange: (String value) {
                            phoneValidate();
                          },
                        ),
                        AppUtils.widgetGetErrorUI(_phoneStream),
                        AllFieldWidget(
                          format: FORMAT.PASSWORD,
                          controller: passwordController,
                          field: 'Password*',
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
                        _widgetForgotPassword(),
                        const SizedBox(height: 15),
                        FillButtonWidget(
                          height: 46,
                          fontSize: 16,
                          title: 'Login',
                          onPressed: () {
                            loginAPI();
                          },
                        ),
                        Gap(h: 15),
                        Row(
                          children: [
                            Expanded(child: CustomLine()),
                            TextSemi(str: '  Or  '),
                            Expanded(child: CustomLine()),
                          ],
                        ),
                        Gap(h: 15),
                        BorderlineButtonWidget(
                          height: 46,
                          borderColor: AppColor.color_1E6F46,
                          child: TextSemi(
                            color: AppColor.color_1E6F46,
                            size: 15,
                            str: 'Create Account ( For Customers )',
                          ),
                          onPressed: () {
                            AppUtils.launchScreen(context, SignUpPage(userType: 3));
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
                                    TextSemi(
                                      str: 'Vendors and Delivery Partners',
                                      size: 16,
                                    ),
                                    TextRegular(
                                      size: 14,
                                      str:
                                          'Please login using the credentials provided by your administrator. ',
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

  Widget _widgetForgotPassword() {
    return Align(
      alignment: Alignment.topRight,
      child: ClickText(
        onPressed: () {},
        child: Text(
          'Forgot Password ?',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.color_1E6F46,
            fontFamily: Fonts.MEDIUM,
            decorationColor: AppColor.color_1E6F46,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _widgetNoAccount() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              AppUtils.launchScreen(context, SignUpPage(userType: widget.userType));
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                ' Sign Up ()',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.color_1E6F46,
                  fontFamily: Fonts.MEDIUM,
                  decorationColor: AppColor.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
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

  bool phoneValidate() {
    var str = mobileController.text.trim();
    if (str.isEmpty) {
      _phoneStream.sink.add('Phone Number is required');
      return false;
    } else if (str.length != 10) {
      _phoneStream.sink.add('Phone Number must have 10 chars');
      return false;
    }
    _phoneStream.sink.add('');
    return true;
  }

  bool passwordValidate() {
    var str = passwordController.text.trim();
    if (str.isEmpty) {
      _passwordStream.sink.add('Password is required');
      return false;
    }
    _passwordStream.sink.add('');

    return true;
  }

  void loginAPI() {
    AppUtils.isNetwork().then((value) {
      print('SSSSSSS $value');

      if (value) {
        String mobileNumber = mobileController.text.trim().toLowerCase();
        String password = passwordController.text;

        bool isEmail = false;
        if (phoneValidate()) {
          isEmail = true;
        }

        bool isPassword = false;
        if (passwordValidate()) {
          isPassword = true;
        }

        if (isEmail && isPassword) {
          AppUtils.hideKeyboard(context);
          _loginBloc.customerLogin(mobileNumber, password);
        }
      }
    });
  }

  void setObservables() {
    //success listener
    _loginBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.LOGIN:
          {
            var res = UserResponse.fromJson(map);
            print('res ${res.token}');
            print('res ${res.data?.name}');
            PreferenceUtil.saveUserProfile(res.data);
            ACCESS_TOKEN = res.token ?? '';
            print('MMMMMMM ACCESS_TOKEN $ACCESS_TOKEN');
            PreferenceUtil.setAccessToken(res.token);
            USER_DATA = res.data;
            if (res.data?.userType == UserType.USER) {
              AppUtils.launchScreenRemoveAll(context, DashboardPage());
            } else {
              AppUtils.launchScreenRemoveAll(context, VendorHomePage());
            }
          }
      }
    });
    //error listener
    _loginBloc.apiError.listen((error) {
      print('error $error');

      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
