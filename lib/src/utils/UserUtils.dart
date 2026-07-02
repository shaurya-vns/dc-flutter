import 'app_constant.dart';

class UserUtils {
  static String name() {
    return USER_DATA?.name ?? '';
  }

  static String phone() {
    return USER_DATA?.phoneNumber ?? '';
  }
}
