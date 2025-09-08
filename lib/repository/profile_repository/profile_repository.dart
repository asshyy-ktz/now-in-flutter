import 'package:flutter_app_structure/data/network/base_api_services.dart';

abstract class ProfileRepository {}

class ProfileRepositoryImpl extends ProfileRepository {
  final BaseApiServices _apiService;
  ProfileRepositoryImpl({required BaseApiServices apiService})
    : _apiService = apiService;
}
