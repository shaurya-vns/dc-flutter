import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../countrypicker/CountryModel.dart';
import '../../../../countrypicker/country_picker_utils.dart';
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
import '../login/login_page.dart';
import 'sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  final String? emailId;

  SignUpPage({required this.emailId});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpBloc _signUpBloc;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final StreamController<String> _firstNameStream = BehaviorSubject();
  final StreamController<String> _lastNameStream = BehaviorSubject();
  final StreamController<CountryModel?> _phoneCodeStream = BehaviorSubject();
  final StreamController<String> _mobileNumberStream = BehaviorSubject();
  final StreamController<String> _passwordStream = BehaviorSubject();
  final StreamController<String> _checkTerms = BehaviorSubject();

  String? countryCode = '+91';
  String codeFlag = 'assets/flags/flag_in.png';

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode mobileNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.color_0A1B35,
      body: SafeArea(
        child: BaseWidget(
          progressLoaderStream: _signUpBloc.progressLoaderStream,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _widgetNoAccount(),
                _widgetField(firstNameNode, lastNameNode),
                _widgetMobileUI(mobileNode, passwordNode),
                _widgetPasswordUI(),
                _widgetCheckBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: Sizes.left_25),
                  child: AppUtils.widgetGetErrorUI(_checkTerms),
                ),
                const SizedBox(height: 5),
                _widgetSignUp(),
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
            'Already have an account?',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.color_0E1E2E,
              fontFamily: Fonts.MEDIUM,
            ),
          ),
          InkWell(
            onTap: () {
              AppUtils.launchScreenRemoveAll(context, LoginPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.color_B0B0B0,
                  fontFamily: Fonts.MEDIUM,
                  decorationColor: AppColor.color_B0B0B0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetField(FocusNode firstNameNode, FocusNode lastNameNode) {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 25),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _widgetFirstNameUI('First Name', firstNameNode, lastNameNode),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _widgetLastNameUI('Last Name', lastNameNode, mobileNode),
          ),
        ],
      ),
    );
  }

  Widget _widgetFirstNameUI(String name, FocusNode preNode, FocusNode nextNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WidgetUtils.getFieldValue(name, isStart: true),
        const SizedBox(height: 5),
        StreamBuilder<String>(
          stream: _firstNameStream.stream,
          builder: (context, snapshot) {
            String error = '';
            if (snapshot.hasData) {
              error = snapshot.data ?? '';
            }
            return _widgetFirstNameField(error, name, preNode, nextNode);
          },
        ),
        const SizedBox(height: 5),
        AppUtils.widgetGetErrorUI(_firstNameStream),
      ],
    );
  }

  Widget _widgetFirstNameField(
    String error,
    String name,
    FocusNode? preNode,
    FocusNode? nextNode,
  ) {
    return TextField(
      focusNode: preNode,
      onChanged: (value) {
        firstNameValid(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onEditingComplete: () {
        if (nextNode == null) {
          FocusScope.of(context).unfocus();
        } else {
          FocusScope.of(context).requestFocus(nextNode);
        }
      },
      textCapitalization: TextCapitalization.words,
      inputFormatters: [FilteringTextInputFormatter(RegExp(r'[a-z,A-Z ]'), allow: true)],
      cursorColor: AppColor.color_0A1B35,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      maxLength: 25,
      controller: firstNameController,
      style: const TextStyle(
        color: AppColor.color_0A1B35,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error == '' ? AppColor.colorBlue : AppColor.red,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.color_D6D6D6, width: 1),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: AppColor.color_BBBBBB,
          fontFamily: Fonts.LIGHT,
          fontSize: 15,
        ),
        hintText: name,
        fillColor: AppColor.white,
      ),
    );
  }

  Widget _widgetLastNameUI(String name, FocusNode preNode, FocusNode nextNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WidgetUtils.getFieldValue(name, isStart: true),
        const SizedBox(height: 5),
        StreamBuilder<String>(
          stream: _lastNameStream.stream,
          builder: (context, snapshot) {
            String error = '';
            if (snapshot.hasData) {
              error = snapshot.data ?? '';
            }
            return _widgetLastNameField(error, name, preNode, nextNode);
          },
        ),
        const SizedBox(height: 5),
        AppUtils.widgetGetErrorUI(_lastNameStream),
      ],
    );
  }

  Widget _widgetLastNameField(
    String error,
    String name,
    FocusNode? preNode,
    FocusNode? nextNode,
  ) {
    return TextField(
      onChanged: (value) {
        lastNameValid(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      focusNode: preNode,
      onEditingComplete: () {
        if (nextNode == null) {
          FocusScope.of(context).unfocus();
        } else {
          FocusScope.of(context).requestFocus(nextNode);
        }
      },
      textCapitalization: TextCapitalization.words,
      inputFormatters: [FilteringTextInputFormatter(RegExp(r'[a-z,A-Z ]'), allow: true)],
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      maxLength: 25,
      controller: lastNameController,
      style: const TextStyle(
        color: AppColor.color_0A1B35,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error == '' ? AppColor.colorBlue : AppColor.color_B0B0B0,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.color_D6D6D6, width: 1),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: AppColor.color_BBBBBB,
          fontFamily: Fonts.LIGHT,
          fontSize: 15,
        ),
        hintText: name,
        fillColor: AppColor.white,
      ),
    );
  }

  Widget _widgetMobileUI(FocusNode? preNode, FocusNode? nextNode) {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetUtils.getFieldValue('Mobile Number', isStart: true),
          const SizedBox(height: 5),
          StreamBuilder<String>(
            stream: _mobileNumberStream.stream,
            builder: (context, snapshot) {
              String error = '';
              if (snapshot.hasData) {
                error = snapshot.data ?? '';
              }
              return _widgetMobileField(error, preNode, nextNode);
            },
          ),
          const SizedBox(height: 5),
          AppUtils.widgetGetErrorUI(_mobileNumberStream),
        ],
      ),
    );
  }

  Widget _widgetMobileField(String error, FocusNode? preNode, FocusNode? nextNode) {
    return Row(
      children: [
        _widgetPhoneCode(error),
        Expanded(
          flex: 1,
          child: TextField(
            focusNode: preNode,
            onChanged: (value) {
              mobileNumber(value);
            },
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            inputFormatters: [FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)],
            onEditingComplete: () {
              if (nextNode == null) {
                FocusScope.of(context).unfocus();
              } else {
                FocusScope.of(context).requestFocus(nextNode);
              }
            },
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            maxLength: 20,
            controller: mobileNumberController,
            style: const TextStyle(
              color: AppColor.color_0A1B35,
              fontFamily: Fonts.LIGHT,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.only(
                left: 20,
                right: 30,
                top: 15,
                bottom: 15,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: error == '' ? AppColor.colorBlue : AppColor.color_B0B0B0,
                  width: 1,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                borderSide: BorderSide(color: AppColor.color_D6D6D6, width: 1),
              ),
              filled: true,
              hintStyle: TextStyle(
                color: AppColor.color_BBBBBB,
                fontFamily: Fonts.LIGHT,
                fontSize: 15,
              ),
              hintText: 'Mobile Number',
              fillColor: AppColor.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetPhoneCode(String error) {
    return StreamBuilder<CountryModel?>(
      stream: _phoneCodeStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          countryCode = snapshot.data?.dialCode ?? countryCode;
          codeFlag = snapshot.data?.flag ?? codeFlag;
        }
        return SizedBox(
          height: 53,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.only(left: 10, right: 10),
              side: const BorderSide(width: 1, color: AppColor.color_D6D6D6),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              CountryPickerUtils().showCountryPicker(
                context,
                onItemClick: (country) {
                  _phoneCodeStream.sink.add(country);
                },
              );
            },
            child: Row(
              children: [
                Image.asset(codeFlag, width: 25, height: 23),
                const SizedBox(width: 7),
                Text(
                  countryCode ?? '+91',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: Fonts.MEDIUM,
                    color: AppColor.color_0E1E2E,
                  ),
                ),
                const SizedBox(width: 7),
                Image.asset(
                  color: AppColor.color_0E1E2E,
                  DrawableConstant.ic_tab_1,
                  width: 13,
                  height: 7,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _widgetPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetUtils.getFieldValue('Password', isStart: true),
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
      focusNode: passwordNode,
      onChanged: (value) {
        passwordValid(value);
      },
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      maxLength: 18,
      controller: passwordController,
      obscureText: !_showPassword,
      style: const TextStyle(
        color: AppColor.color_0A1B35,
        fontFamily: Fonts.LIGHT,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(left: 20, right: 30, top: 15, bottom: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error == '' ? AppColor.colorBlue : AppColor.color_DE6262,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            icon:
                _showPassword
                    ? Image.asset(DrawableConstant.icPassword1, width: 24, height: 24)
                    : Image.asset(DrawableConstant.icPassword2, width: 24, height: 24),
            onPressed: () {
              setState(() => _showPassword = !this._showPassword);
            },
          ),
        ),
      ),
    );
  }

  bool _showCheckBox = false;

  Widget _widgetCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 25, top: 0),
      child: Row(
        children: [
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Icon(
              _showCheckBox ? Icons.check_box : Icons.check_box_outline_blank,
              color: _showCheckBox ? AppColor.colorBlue : Colors.grey,
            ),
            onPressed: () {
              setState(() => _showCheckBox = !_showCheckBox);
              checkValid();
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "I agree to CSS’s ",
                style: TextStyle(
                  color: AppColor.color_101010,
                  fontSize: 13,
                  fontFamily: Fonts.MEDIUM,
                ),
                children: [
                  TextSpan(
                    text: "Terms of Use",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.black,
                      fontFamily: Fonts.MEDIUM,
                      decorationColor: AppColor.black,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(
                      color: AppColor.color_101010,
                      fontSize: 13,
                      fontFamily: Fonts.MEDIUM,
                    ),
                  ),
                  TextSpan(
                    text: "Privacy Policy. ",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.black,
                      fontFamily: Fonts.MEDIUM,
                      decorationColor: AppColor.black,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetSignUp() {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.left_25, right: Sizes.left_25, top: 10),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: FillButtonWidget(
              title: 'Sign Up',
              bgColor: AppColor.colorBlue,
              onPressed: () {
                sendOtpMobileAPI();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _signUpBloc.onDispose();
  }

  bool firstNameValid(String str) {
    if (str.trim().isEmpty) {
      _firstNameStream.sink.add('First name is required');
      return false;
    } else if (str.trim().length < 2) {
      _firstNameStream.sink.add('2 characters required');
      return false;
    }
    _firstNameStream.sink.add('');
    return true;
  }

  bool lastNameValid(String str) {
    if (str.trim().isEmpty) {
      _lastNameStream.sink.add('Last name is required');
      return false;
    }
    _lastNameStream.sink.add('');
    return true;
  }

  bool mobileNumber(String str) {
    if (str.isEmpty) {
      _mobileNumberStream.sink.add('Mobile number is required');
      return false;
    }
    if (str.length < 5 || str == '0000000000') {
      _mobileNumberStream.sink.add('Enter valid mobile number');
      return false;
    }

    _mobileNumberStream.sink.add('');
    return true;
  }

  bool passwordValid(String str) {
    if (str.isEmpty) {
      _passwordStream.sink.add('Password is required.');
      return false;
    } else if (AppUtils.isNotValidPassword(str)) {
      _passwordStream.sink.add(
        'Password must have at least 8 characters, one uppercase, one lowercase, one number and one special character',
      );
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

  void sendOtpMobileAPI() {}

  void setObservables() {
    //success listener
    _signUpBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.LOGIN:
          {}
      }
    });
    //error listener
    _signUpBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
