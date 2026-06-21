import 'CallbackType.dart';

abstract class RootCallBack<T> {
  void rootCallBack({int index = 0, T? data, CallbackType type});
}
