import 'app.dart';
import 'src/config/app_config.dart';
import 'src/network/api_request_codes.dart';

void main() async {
  BaseUrl.BASE_URL = BaseUrl.prodBaseURL;
  runWithAppConfig(AppConfig());
}
