import 'package:flutter_app_structure/models/login/login_response.dart';
import 'package:flutter_app_structure/utils/app_url/app_url.dart';

abstract class AuthRepository {
  Future<LoginResponse> loginApi(var data);
  Future<Map<String, dynamic>> sendForgotPassword(var data);
  Future<Map<String, dynamic>> verifyOTP(String id, String code);
  Future<bool> renewPassword(var data);
}

class AuthRepositoryImpl extends AuthRepository {
  final _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<LoginResponse> loginApi(var data) async {
    dynamic response = await _apiService.postApi(
      data,
      AppUrl.authenticateWithUserId,
    );

    // Ensure the response is not null and contains the "data" object
    if (response != null) {
      LoginResponse loginResponse = LoginResponse.fromJson(response);

      return loginResponse;
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Future<Map<String, dynamic>> sendForgotPassword(var data) async {
    dynamic response = await _apiService.postApi(
      data,
      AppUrl.sendForgotPassword,
    );

    // Ensure the response is not null and contains the "data" object
    if (response != null && response['data'] != null) {
      Map<String, dynamic> dataObject = response['data'];
      return dataObject;
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String id, String code) async {
    dynamic response = await _apiService.getApi(
      AppUrl.getForgetPasswordVerifyUrl(id, code),
    );

    // Ensure the response is not null and contains the "data" object
    if (response != null && response['data'] != null) {
      Map<String, dynamic> dataObject = response['data'];
      return dataObject;
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Future<bool> renewPassword(var data) async {
    dynamic response = await _apiService.postApi(data, AppUrl.renewPassword);
    if (response != null && response['errors'] == null) {
      return true;
    } else {
      throw Exception('Invalid response format');
    }
  }
}
