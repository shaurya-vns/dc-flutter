import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../network/api_handler.dart';

class CommonBloc {
  late BuildContext _context;

  late ApiHandler _apiHandler;

  final StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  final StreamController _loginApiResponse = StreamController();

  final StreamController _loginApiError = StreamController();

  Stream get apiResponse => _loginApiResponse.stream;

  Stream get apiError => _loginApiError.stream;

  CommonBloc(_context) {
    this._context = _context;
    _apiHandler = ApiHandler(_context);
    _setApiObservable();
  }

  void loginAPI(String phoneNumber, String password) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('phoneNumber', () => phoneNumber);
    map.putIfAbsent('password', () => password);
    _apiHandler.loginAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void getMyTodayOrderAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getMyTodayOrderAPI(map);
  }

  void getMySubscriptionAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getMySubscriptionAPI(map);
  }

  void getProductBySubOwnerIdAPI() async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('subOwnerId', () => 1);
    _apiHandler.getProductBySubOwnerIdAPI(map);
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
