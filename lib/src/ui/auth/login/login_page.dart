import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../constants/fonts.dart';
import '../../../constants/size_constants.dart';
import '../../../model/base_error.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                _widgetNoAccount(),
                _widgetEmailUI(),
                _widgetPasswordUI(),
                _widgetForgotPassword(),
                const SizedBox(height: 20),
                _widgetSignIn(),
                const SizedBox(height: 20),
              ],
            ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Don’t have an account?',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black,
              fontFamily: Fonts.MEDIUM,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black,
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

  Widget _widgetEmailUI() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetUtils.getFieldValue('Email ID'),
          const SizedBox(height: 5),
          StreamBuilder<String>(
            stream: _emailStream.stream,
            builder: (context, snapshot) {
              String error = '';
              if (snapshot.hasData) {
                error = snapshot.data ?? '';
              }
              return WidgetUtils.widgetEmailField(emailController, error, (value) {
                emailValidate(value);
              });
            },
          ),
          const SizedBox(height: 5),
          AppUtils.widgetGetErrorUI(_emailStream),
        ],
      ),
    );
  }

  Widget _widgetPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetUtils.getFieldValue('Password'),
          const SizedBox(height: 5),
          StreamBuilder<String>(
            stream: _passwordStream.stream,
            builder: (context, snapshot) {
              String error = '';
              if (snapshot.hasData) {
                error = snapshot.data ?? '';
              }
              return _widgetPasswordField(error);
            },
          ),
          const SizedBox(height: 5),
          AppUtils.widgetGetErrorUI(_passwordStream),
        ],
      ),
    );
  }

  bool _showPassword = false;

  Widget _widgetPasswordField(String error) {
    return TextField(
      onChanged: (value) {
        passwordValidate(value);
      },
      maxLines: 1,
      maxLength: 18,
      controller: passwordController,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      obscureText: !_showPassword,
      style: const TextStyle(
        color: AppColor.black,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error == '' ? AppColor.colorBlue : AppColor.red,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.color_D6D6D6, width: 1),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: AppColor.color_BBBBBB,
          fontFamily: Fonts.LIGHT,
          fontSize: 15,
        ),
        hintText: 'Enter Password',
        fillColor: AppColor.white,
        suffixIcon: IconButton(
          icon: Image.asset(
            _showPassword ? DrawableConstant.icPassword2 : DrawableConstant.icPassword1,
            width: 25,
            height: 25,
          ),
          onPressed: () {
            setState(() => _showPassword = !_showPassword);
          },
        ),
      ),
    );
  }

  Widget _widgetForgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {},
          child: Text(
            'Forgot Password ?',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.color_B0B0B0,
              fontFamily: Fonts.MEDIUM,
              decorationColor: AppColor.color_B0B0B0,
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
        title: 'Sign in',
        bgColor: AppColor.color_B0B0B0,
        onPressed: () {
          loginAPI();
        },
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
        String email = emailController.text.trim().toLowerCase();
        String password = passwordController.text;

        bool isEmail = false;
        if (emailValidate(email)) {
          isEmail = true;
        }

        bool isPassword = false;
        if (passwordValidate(password)) {
          isPassword = true;
        }

        if (isEmail && isPassword) {
          AppUtils.hideKeyboard(context);
          _loginBloc.loginAPI(email, password);
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
          {}
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
