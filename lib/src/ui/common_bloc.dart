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

  void getNextDayOrderListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getNextDayOrderListAPI(map);
  }

  void getMySubscriptionAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getMySubscriptionAPI(map);
  }

  void getProductListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getProductListAPI(map);
  }

  void getProductDetail(int? productId) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('productId', () => productId);
    _apiHandler.getProductDetail(map);
  }

  void createSubscriptionAPI(
    int? productId,
    int? pricing_options,
    String? start_date,
    int quantity,
    int? addressId,
    bool? isApplyOffer,
  ) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('product', () => productId);
    map.putIfAbsent('pricing_options', () => pricing_options);
    map.putIfAbsent('start_date', () => start_date);
    map.putIfAbsent('quantity', () => quantity);
    map.putIfAbsent('isApplyOffer', () => isApplyOffer);
    map.putIfAbsent('addressId', () => addressId);
    _apiHandler.createSubscriptionAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void createOneTimeOrderAPI(
    int? productId,
    String? delivery_date,
    int quantity,
    int? addressId,
    bool? isApplyOffer,
  ) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('product', () => productId);
    map.putIfAbsent('delivery_date', () => delivery_date);
    map.putIfAbsent('quantity', () => quantity);
    map.putIfAbsent('isApplyOffer', () => false);
    map.putIfAbsent('addressId', () => addressId);
    _apiHandler.createOneTimeOrderAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void getUserAddressListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getUserAddressListAPI(map);
    _progressLoaderController.sink.add(false);
  }

  void getOneTimeTodayOrderListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getOneTimeTodayOrderListAPI(map);
    _progressLoaderController.sink.add(false);
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
