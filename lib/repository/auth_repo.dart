import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:now_in_flutter/data/network/base_api_services.dart';
import 'package:now_in_flutter/data/network/network_api_services.dart';
import 'package:now_in_flutter/resources/app_urls.dart';

class AuthRepository {
  //This apiServices give access of this NetworkApiServices class
  BaseApiServices apiServices = NetworkApiService();
  Future<dynamic> loginApi(dynamic data) async {
    dynamic response = await apiServices.postApiResponse(AppUrl.loginUrl, data);
    try {
      return response;
    } catch (e) {
      debugPrint("${e.printError}");
      rethrow;
    }
  }

  Future<dynamic> registrationApi(dynamic data) async {
    dynamic response =
        await apiServices.postApiResponse(AppUrl.registerUrl, data);
    try {
      return response;
    } catch (e) {
      debugPrint("${e.printError}");
      rethrow;
    }
  }
}
