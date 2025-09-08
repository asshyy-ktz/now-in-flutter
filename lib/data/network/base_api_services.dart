abstract class BaseApiServices {
  Future<dynamic> getApi(String url);
  Future<dynamic> patchApi(dynamic data, String url);
  Future<dynamic> putApi(dynamic data, String url);
  Future<dynamic> postApi(dynamic data, String url);
  Future<dynamic> dynamicPostApi(dynamic data, String url);
  Future<dynamic> putApiWithFormData(
      Map<String, dynamic> formData, Map<String, String>? fileData, String url);
  Future<dynamic> putApiWithRequestBody(dynamic data, String url);
  Future<dynamic> deleteApiWithRequestBody(dynamic data, String url);
  Future<dynamic> deleteApi(String url);
}
