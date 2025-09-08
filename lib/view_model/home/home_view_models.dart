import 'package:flutter_app_structure/data/response/status.dart';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/models/login/login_response.dart';
import 'package:flutter_app_structure/repository/home_repository.dart/home_repository.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef UserDataCallback = void Function(LoginResponse? userData);

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _homeRepository;
  HomeViewModel({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  var isLoading = false;
  UserPreference userPreference = getIt.get<UserPreference>();
  String action = "";
  String module = "";
  String description = "";

  final rxRequestStatus = Status.LOADING.obs;

  RxString error = ''.obs;
  LoginResponse? userDataModel;

  void fetchUserData(UserDataCallback callback) {
    isLoading = true;
    try {
      _homeRepository
          .fetchUserData()
          .then((value) async {
            isLoading = false;
            userDataModel = value;
            // await userPreference.saveUserAuthData(
            //   token: value.token,
            //   userId: value.userId,
            //   userName: value.userName,
            //   firstName: value.firstName,
            //   lastName: value.lastName,
            //   employeeId: value.employeeId,
            // );
            notifyListeners();
            callback(value);
          })
          .onError((error, stackTrace) {
            isLoading = false;
            notifyListeners();
            callback(null);
          });
    } catch (error) {
      isLoading = false;
      print('Error fetching user data: $error');
      notifyListeners();
      callback(null);
    }
  }
}
