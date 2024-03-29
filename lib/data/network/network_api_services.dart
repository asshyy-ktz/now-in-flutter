import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:now_in_flutter/data/app_exception.dart';
import 'package:now_in_flutter/data/network/base_api_services.dart';

class NetworkApiService extends BaseApiServices {
  //For Get Api's
  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      http.Response response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Connection");
    }

    //if true then it'll return jso response
    return responseJson;
  }

  //For post Api's
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Connection");
    }

    //if true then it'll return jso response
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(message: response.body.toString());
      case 401:
        throw UnAuthorizedException(message: response.body.toString());
      default:
        throw FetchDataException(
            message:
                "Error occurred while communicating with server with status code${response.statusCode}");
    }
  }
}
