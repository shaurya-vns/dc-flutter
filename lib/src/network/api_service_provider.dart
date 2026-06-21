/// This class creates a layer of separation between network calling and response provider
abstract class ApiServiceProvider {
  ///Used to make POST API Requests
  /// @url POST Api Url
  /// @request Request params
  Future<dynamic> apiPostRequest(
    context,
    String url,
    Map<String, dynamic> request,
  );

  ///Used to make PUT API Requests
  /// @url PUT Api Url
  /// @request Request params
  Future<dynamic> apiPutRequest(
    context,
    String url,
    Map<String, dynamic> request,
  );

  ///Used to make GET API Requests
  /// @url GET Api Url
  Future<dynamic> apiGetRequest(context, String url);

  ///Used to make DELETE API Requests
  /// @url DELETE Api Url
  Future<dynamic> apiDeleteRequest(String url);
}
