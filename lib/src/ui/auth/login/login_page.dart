import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/auth/signup/sign_up_page.dart';
import 'package:flutter_dc/src/ui/dashboard/dashboard_page.dart';
import 'package:flutter_dc/src/ui/vendor/dashboard/vendor_dashboard_page.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/all_field_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
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
import '../../../utils/widgetUtils.dart';
import '../../../widget/base_widget.dart';
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

  bool isCustomer = false;

  @override
  void initState() {
    isCustomer = widget.userType == UserType.USER;
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
      backgroundColor: const Color(0xffF5F7FA),
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
          Gap(h: 10),
          Row(
            children: [
              Gap(w: 20),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, size: 25),
              ),
            ],
          ),
          Hero(
            tag: "logo",
            child: CircleAvatar(
              radius: 55,
              backgroundColor:
                  isCustomer ? Colors.green.shade100 : Colors.orange.shade100,
              child: Icon(
                isCustomer ? Icons.person : Icons.storefront,
                size: 60,
                color: isCustomer ? Colors.green : Colors.orange,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Text(
            isCustomer ? "Customer Login" : "Sub Owner Login",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            isCustomer
                ? "Sign in to order delicious homemade meals."
                : "Sign in to manage your products and orders.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _widgetAuthUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          WidgetUtils.getFieldValue('Phone Number', isStart: true),
          AllFieldWidget(
            format: FORMAT.PHONE,
            controller: mobileController,
            field: 'Enter Phone Number',
            preNode: mobileNode,
            nextNode: passwordNode,
            max: 10,
            icon: Icons.phone,
            onTypeChange: (String value) {
              phoneValidate();
            },
          ),
          AppUtils.widgetGetErrorUI(_phoneStream),
          const SizedBox(height: 15),
          WidgetUtils.getFieldValue('Password', isStart: true),
          AllFieldWidget(
            format: FORMAT.PASSWORD,
            controller: passwordController,
            field: 'Enter Password',
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
          color: AppColor.trans,
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
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
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
            onTap: () {
              AppUtils.launchScreen(context, SignUpPage(userType: widget.userType));
            },
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

          if (widget.userType == UserType.USER) {
            _loginBloc.customerLogin(mobileNumber, password);
          } else {
            _loginBloc.subOwnerLogin(mobileNumber, password);
          }
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
            AppUtils.launchScreen(context, DashboardPage());
          }
        case ApiType.SUB_OWNER_LOGIN:
          {
            var res = UserResponse.fromJson(map);
            print('res ${res.token}');
            print('res ${res.data?.name}');
            PreferenceUtil.saveUserProfile(res.data);
            ACCESS_TOKEN = res.token ?? '';
            print('MMMMMMM ACCESS_TOKEN $ACCESS_TOKEN');
            PreferenceUtil.setAccessToken(res.token);
            USER_DATA = res.data;
            AppUtils.launchScreen(context, VendorDashboardPage());
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
