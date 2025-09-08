import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_app_structure/data/auth/auth_manager.dart';
import 'package:flutter_app_structure/data/network/base_api_services.dart';
import 'package:flutter_app_structure/data/network/connectivity_service.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  final UserPreference _preferences;

  NetworkApiServices(this._preferences, AuthManager authManager);

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _preferences.getToken() ?? "";
    String deviceType = await _getDeviceType();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'deviceType': deviceType,
    };

    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<String> _getDeviceType() async {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Other';
    }
  }

  @override
  Future<dynamic> getApi(String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 120));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();
    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> patchApi(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();
    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> putApi(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();
    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> dynamicPostApi(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .post(Uri.parse(url), headers: headers, body: (data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> putApiWithFormData(
    Map<String, dynamic> formData,
    Map<String, String>? fileData,
    String url,
  ) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("FormData: ${formData.toString()}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..headers.addAll(headers);

      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (fileData != null) {
        fileData.forEach((key, filePath) async {
          request.files.add(await http.MultipartFile.fromPath(key, filePath));
        });
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> putApiWithRequestBody(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> deleteApiWithRequestBody(var data, String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("Payload: ${jsonEncode(data)}");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .delete(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> deleteApi(String url) async {
    if (!Get.find<ConnectivityService>().hasInternet.value) {
      throw InternetException();
    }

    Map<String, String> headers = await _getHeaders();

    log("API URL: $url");
    log("Headers ${headers.toString()}");

    dynamic responseJson;
    try {
      var response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 120));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) async {
    log("Status code ${response.statusCode.toString()}");
    log("Response ${response.body.toString()}");
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          dynamic responseJson = jsonDecode(response.body);
          return responseJson;
        } catch (e) {
          print("Exception");
          e.printError();
          e.printInfo();
        }

      default:

        // dynamic responseJson = jsonDecode(response.body);
        // String errorMessage = tr(somethingWentWrong);
        // if (responseJson["message"] == "password_expired") {
        //   errorMessage = tr(passwordExpired);
        // } else if (responseJson["message"] == "game_requests_limit_exceeds") {
        //   errorMessage = tr(limitExceed);
        // }

        throw FetchDataException(response.body);
    }
  }
}
