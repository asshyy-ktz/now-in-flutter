import 'package:flutter_app_structure/repository/profile_repository/profile_repository.dart';
import 'package:flutter_app_structure/utils/dialog_helper.dart';
import 'package:flutter_app_structure/view_model/loading_view_model.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends LoadingViewModel {
  final ProfileRepository _profileRepository;

  ProfileViewModel({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  Future<void> fetchExpenses(Function callback) async {
    isLoading = true;
  }

  void showConfirmationPopup(BuildContext context, Function() callback) {
    print("Showing confirmation popup..");
    DialogHelper().showConfirmationDialog(
      context: context,
      title: "Logout?",
      description: "Are you sure you want to logout?",
      affirmativeAction: () {
        callback();
      },
      negativeAction: () {},
    );
  }
}
