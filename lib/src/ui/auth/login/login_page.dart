import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/all_field_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../constants/fonts.dart';
import '../../../constants/size_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/user/UserResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/preference_util.dart';
import '../../../utils/widgetUtils.dart';
import '../../../widget/base_widget.dart';
import '../../../widget/fill_button_widget.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode mobileNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final StreamController<String> _emailStream = BehaviorSubject();
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
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: BaseWidget(
          progressLoaderStream: _loginBloc.progressLoaderStream,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _widgetUI(),
                _widgetAuthUI(),
                _widgetForgotPassword(),
                const SizedBox(height: 30),
                _widgetSignIn(),
                Gap(h: 20),
                _widgetNoAccount(),
                const SizedBox(height: 40),
                widgetTerms(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetUI() {
    return Container(
      width: SCREEN_WIDTH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Gap(h: 20),
          Image.asset(DrawableConstant.ic_splash, width: 100, height: 100),
          TextSemi(str: 'Login to POC', color: AppColor.black, size: 16, align: 2),
        ],
      ),
    );
  }

  Widget _widgetAuthUI() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetUtils.getFieldValue('Phone Number', isStart: true),
          const SizedBox(height: 5),
          AllFieldWidget(
            format: FORMAT.PHONE,
            controller: mobileController,
            field: 'Enter Phone Number ( 10 digits only)',
            preNode: mobileNode,
            nextNode: passwordNode,
            max: 10,
            onTypeChange: (String value) {},
          ),
          AppUtils.widgetGetErrorUI(_emailStream),
          const SizedBox(height: 15),
          WidgetUtils.getFieldValue('Password', isStart: true),
          const SizedBox(height: 5),
          AllFieldWidget(
            format: FORMAT.PASSWORD,
            controller: passwordController,
            field: 'Enter Password',
            preNode: passwordNode,
            nextNode: null,
            max: 30,
            isPassword: true,
            onTypeChange: (String value) {},
          ),
          AppUtils.widgetGetErrorUI(_passwordStream),
        ],
      ),
    );
  }

  Widget _widgetForgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.topRight,
        child: FixButtonWidget(
          borderColor: AppColor.trans,
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
      ),
    );
  }

  Widget _widgetSignIn() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 10),
      child: FillButtonWidget(
        title: 'Login',
        onPressed: () {
          loginAPI();
        },
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
          const Text(
            'Don’t have an account?',
            style: TextStyle(
              fontSize: 15,
              color: AppColor.black,
              fontFamily: Fonts.MEDIUM,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                ' Sign Up',
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
                  fontSize: 14,
                  fontFamily: Fonts.REGULAR,
                  color: AppColor.black,
                ),
              ),
              TextSpan(
                text: "Terms & Policy",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  color: AppColor.color_B0B0B0,
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

  bool emailValidate(String email) {
    if (email.isEmpty) {
      _emailStream.sink.add('Email id is required');
      return false;
    } else if (AppUtils.isNotValidEmail(email)) {
      _emailStream.sink.add('Email id is invalid');
      return false;
    }
    _emailStream.sink.add('');
    return true;
  }

  bool passwordValidate(String password) {
    if (password.isEmpty) {
      _passwordStream.sink.add('Password is required');
      return false;
    }
    _passwordStream.sink.add('');

    return true;
  }

  void loginAPI() {
    AppUtils.isNetwork().then((value) {
      if (value) {
        String mobileNumber = '9876543211'; //mobileController.text.trim().toLowerCase();
        String password = '123456'; //passwordController.text;
        _loginBloc.loginAPI(mobileNumber, password);

        /* bool isEmail = false;
        if (emailValidate(mobileNumber)) {
          isEmail = true;
        }

        bool isPassword = false;
        if (passwordValidate(password)) {
          isPassword = true;
        }

        if (isEmail && isPassword) {
          AppUtils.hideKeyboard(context);
          _loginBloc.loginAPI(mobileNumber, password);
        }*/
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
            AppUtils.launchScreen(context, DashboardPage());
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
