import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../../../network/api_handler.dart';

class LoginBloc {
  late BuildContext _context;

  late ApiHandler _apiHandler;

  final StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  final StreamController _loginApiResponse = StreamController();

  final StreamController _loginApiError = StreamController();

  Stream get apiResponse => _loginApiResponse.stream;

  Stream get apiError => _loginApiError.stream;

  LoginBloc(_context) {
    this._context = _context;
    _apiHandler = ApiHandler(_context);
    _setApiObservable();
  }

  void loginAPI(String email, String password) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('emailId', () => email.toLowerCase());
    map.putIfAbsent('password', () => password);

    _progressLoaderController.sink.add(true);
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
