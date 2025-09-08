import 'package:flutter_app_structure/data/network/base_api_services.dart';
import 'package:flutter_app_structure/models/login/login_response.dart';
import 'package:flutter_app_structure/utils/app_url/app_url.dart';
import 'package:get/get_utils/get_utils.dart';

abstract class HomeRepository {
  Future<LoginResponse> fetchUserData();
}

class HomeRepositoryImpl extends HomeRepository {
  BaseApiServices _apiService;

  HomeRepositoryImpl(this._apiService);

  @override
  Future<LoginResponse> fetchUserData() async {
    var response = await _apiService.getApi(AppUrl.getUserProfileAPI);

    if (response != null) {
      try {
        LoginResponse loginResponse = LoginResponse.fromJson(response);

        return loginResponse;
      } catch (e, stackTrace) {
        e.printError();
        e.printInfo();
        stackTrace.printError();
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
