import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
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

  void getProductListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getProductListAPI(map);
  }

  void getSubscriptionOrderAPI(int? userId, {String? delivery_date}) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('delivery_date', () => delivery_date);
    _apiHandler.getSubscriptionOrderAPI(map);
  }

  void getOneTimeOrderListAPI(int? userId, {String? delivery_date}) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('delivery_date', () => delivery_date);
    _apiHandler.getOneTimeOrderListAPI(map);
    _progressLoaderController.sink.add(false);
  }

  void getMySubscriptionAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getMySubscriptionAPI(map);
  }

  void getAllSubscriptionAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllSubscriptionAPI(map);
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
    map.putIfAbsent('userId', () => USER_DATA?.id);
    _apiHandler.getUserAddressListAPI(map);
    _progressLoaderController.sink.add(false);
  }

  void addAddressAPI(Map<String, dynamic> body) async {
    _apiHandler.addAddressAPI(body);
    _progressLoaderController.sink.add(false);
  }

  void updateAddressAPI(int? addressId, Map? data) async {
    _apiHandler.updateAddressAPI(addressId, data);
    _progressLoaderController.sink.add(false);
  }

  void getAllSubOrderListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllSubOrderListAPI(map);
    _progressLoaderController.sink.add(false);
  }

  void getAllOneTimeOrderListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllOneTimeOrderListAPI(map);
    _progressLoaderController.sink.add(false);
  }

  void getUserProfile() async {
    Map map = <String, dynamic>{};
    _apiHandler.getUserProfile(map);
    _progressLoaderController.sink.add(false);
  }

  void getAllSubOrderList() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllSubOrderList(map);
    _progressLoaderController.sink.add(false);
  }

  void getAllOneTimeOrderList() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllOneTimeOrderList(map);
    _progressLoaderController.sink.add(false);
  }

  void updateSubOrderAPI(int? orderId, int? status) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('status', () => status);
    _apiHandler.updateSubOrderAPI(orderId, map);
    _progressLoaderController.sink.add(true);
  }

  void updateOneTimeOrderAPI(int? orderId, int? status) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('status', () => status);
    _apiHandler.updateOneTimeOrderAPI(orderId, map);
    _progressLoaderController.sink.add(true);
  }

  void subscriptionApproveAPI(int? subscriptionId) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('subscriptionId', () => subscriptionId);
    _apiHandler.subscriptionApproveAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void getAllUserList() async {
    Map map = <String, dynamic>{};
    _apiHandler.getAllUserList(map);
    _progressLoaderController.sink.add(true);
  }

  void getUserTodayOrderAPI(int? userId) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('userId', () => userId);
    _apiHandler.getUserTodayOrderAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void createOnDemandOrderAPI(
    int? address,
    String? itemName,
    int quantity,
    String? deliveryDate,
    String? mealType,
    String? userAmount,
    String? note,
  ) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('address', () => address);
    map.putIfAbsent('itemName', () => itemName);
    map.putIfAbsent('quantity', () => quantity);
    map.putIfAbsent('deliveryDate', () => deliveryDate);
    map.putIfAbsent('mealType', () => mealType);
    map.putIfAbsent('userAmount', () => userAmount);
    map.putIfAbsent('note', () => note);
    _apiHandler.createOnDemandOrderAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void getOnDemandListAPI() async {
    Map map = <String, dynamic>{};
    _apiHandler.getOnDemandListAPI(map);
    _progressLoaderController.sink.add(true);
  }

  void userApproveOnDemandAPI(int? orderId) async {
    _apiHandler.userApproveOnDemandAPI(orderId);
    _progressLoaderController.sink.add(true);
  }

  void userCancelOnDemandAPI(int? orderId, String reason) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('cancelReason', () => reason);
    _apiHandler.userCancelOnDemandAPI(orderId, map);
    _progressLoaderController.sink.add(true);
  }

  void vendorApproveOnDemandAPI(int? orderId) async {
    _apiHandler.vendorApproveOnDemandAPI(orderId);
    _progressLoaderController.sink.add(true);
  }

  void vendorRejectOnDemandAPI(int? orderId, String reason) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('rejectReason', () => reason);
    _apiHandler.vendorRejectOnDemandAPI(orderId, map);
    _progressLoaderController.sink.add(true);
  }

  void vendorAmountOnDemandAPI(int? orderId, String? vendorAmount) async {
    Map map = <String, dynamic>{};
    map.putIfAbsent('vendorAmount', () => vendorAmount);
    _apiHandler.vendorAmountOnDemandAPI(orderId, map);
    _progressLoaderController.sink.add(true);
  }

  void vendorPaymentOnDemandAPI(int? orderId) async {
    _apiHandler.vendorPaymentOnDemandAPI(orderId);
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
