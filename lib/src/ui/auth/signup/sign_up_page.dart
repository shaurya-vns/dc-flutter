import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/fonts.dart';
import '../../../model/base_error.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../utils/widgetUtils.dart';
import '../../../widget/all_field_widget.dart';
import '../../../widget/base_widget.dart';
import '../../../widget/fill_button_widget.dart';
import 'sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  final int? userType;

  SignUpPage({required this.userType});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpBloc _signUpBloc;

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
  bool isCustomer = false;

  @override
  void initState() {
    isCustomer = widget.userType == UserType.USER;
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
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: BaseWidget(
          progressLoaderStream: _signUpBloc.progressLoaderStream,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _widgetNoAccount(),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      WidgetUtils.getFieldValue('Name', isStart: true),
                      AllFieldWidget(
                        format: FORMAT.ALL,
                        controller: firstNameController,
                        field: 'Enter Name',
                        preNode: firstNameNode,
                        nextNode: mobileNode,
                        max: 50,
                        icon: Icons.supervised_user_circle_outlined,
                        onTypeChange: (String value) {
                          nameValid();
                        },
                      ),
                      AppUtils.widgetGetErrorUI(_firstNameStream),
                      const SizedBox(height: 15),
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
                      AppUtils.widgetGetErrorUI(_mobileNumberStream),
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

                      _widgetCheckBox(),
                      AppUtils.widgetGetErrorUI(_checkTerms),
                      const SizedBox(height: 5),
                      _widgetSignUp(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetNoAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: isCustomer ? Colors.green.shade50 : Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCustomer ? Icons.person : Icons.store,
            size: 45,
            color: isCustomer ? Colors.green : Colors.orange,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isCustomer ? "Customer Register" : "Sub Owner Register",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text("Create your account", style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 30),
      ],
    );
  }

  bool _showCheckBox = false;

  Widget _widgetCheckBox() {
    return Row(
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
    );
  }

  Widget _widgetSignUp() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: FillButtonWidget(
            title: 'Sign Up',
            onPressed: () {
              signUpAPI();
            },
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _signUpBloc.onDispose();
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
        String name = firstNameController.text.trim().toLowerCase();
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
          //_signUpBloc.loginAPI(mobileNumber, password);
        }
      }
    });
  }

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
