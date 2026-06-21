import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../network/api_handler.dart';

class SignUpBloc {
  late BuildContext _context;

  late ApiHandler _apiHandler;

  final StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  final StreamController _loginApiResponse = StreamController();

  final StreamController _loginApiError = StreamController();

  Stream get apiResponse => _loginApiResponse.stream;

  Stream get apiError => _loginApiError.stream;

  SignUpBloc(_context) {
    this._context = _context;
    _apiHandler = ApiHandler(_context);
    _setApiObservable();
  }

  void sendOtpMobileAPI({
    String? emailId,
    String? firstName,
    String? lastName,
    String? countryCode,
    String? phoneNumber,
    String? password,
  }) async {
    _progressLoaderController.sink.add(true);
    Map map = <String, dynamic>{};
    map.putIfAbsent('emailId', () => emailId?.toLowerCase());
    map.putIfAbsent('firstName', () => firstName);
    map.putIfAbsent('lastName', () => lastName);
    map.putIfAbsent('countryCode', () => countryCode);
    map.putIfAbsent('phoneNumber', () => phoneNumber);
    map.putIfAbsent('password', () => password);
    map.putIfAbsent('termsCondition', () => true);
  }

  onDispose() {
    _apiHandler.onDispose();
    _loginApiResponse.close();
    _loginApiError.close();
    _progressLoaderController.close();
  }

  void _setApiObservable() {
    _apiHandler.onApiSuccess.listen((map) {
      _progressLoaderController.sink.add(false);
      _loginApiResponse.sink.add(map);
    });

    _apiHandler.onApiError.listen((e) {
      _progressLoaderController.sink.add(false);
      _loginApiError.sink.add(e);
    });
  }
}
