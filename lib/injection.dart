import 'package:flutter_app_structure/data/auth/auth_manager.dart';
import 'package:flutter_app_structure/data/network/base_api_services.dart';
import 'package:flutter_app_structure/data/network/network_api_services.dart';
import 'package:flutter_app_structure/repository/auth_repository/auth_repository.dart';
import 'package:flutter_app_structure/repository/home_repository.dart/home_repository.dart';
import 'package:flutter_app_structure/repository/profile_repository/profile_repository.dart';
import 'package:flutter_app_structure/view_model/home/home_view_models.dart';
import 'package:flutter_app_structure/view_model/profile/profile_view_model.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setupModules() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<UserPreference>(
    UserPreference(getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<AuthManager>(AuthManager(localPref: getIt.get()));

  getIt.registerSingleton<BaseApiServices>(
    NetworkApiServices(getIt<UserPreference>(), getIt<AuthManager>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<BaseApiServices>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(apiService: getIt<BaseApiServices>()),
  );



  getIt.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(profileRepository: getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<HomeViewModel>(
    () => HomeViewModel(homeRepository: getIt<HomeRepository>()),
  );
}
