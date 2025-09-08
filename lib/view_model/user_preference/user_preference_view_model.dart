import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  final SharedPreferences _preferences;

  UserPreference(this._preferences);

  Future<void> saveUserAuthData({
    required String token,
    required String userId,
    required String userName,
    required String firstName,
    required String lastName,
    required String employeeId,
  }) async {
    await _preferences.setString('token', token);
    await _preferences.setString('userId', userId);
    await _preferences.setString('userName', userName);
    await _preferences.setString('firstName', firstName);
    await _preferences.setString('lastName', lastName);
    await _preferences.setString('employeeId', employeeId);
  }

  Future<void> saveUserCredentials({
    required String email,
    required String password,
  }) async {
    await _preferences.setString('email', email);
    await _preferences.setString('password', password);
  }

  Future<void> removeUserData() async {
    await _preferences.remove('token');
    await _preferences.remove('userId');
    await _preferences.remove('userName');
    await _preferences.remove('firstName');
    await _preferences.remove('lastName');
    await _preferences.remove('employeeId');
  }

  Future<void> removeUserCredentials() async {
    await _preferences.remove('email');
    await _preferences.remove('password');
  }

  Future<String?> getUserId() async {
    return _preferences.getString('userId');
  }

  Future<String?> getUserName() async {
    return _preferences.getString('userName');
  }

  Future<String?> getFirstName() async {
    return _preferences.getString('firstName');
  }

  Future<String?> getLastName() async {
    return _preferences.getString('lastName');
  }

 

  Future<String?> getEmail() async {
    return _preferences.getString('email');
  }

  Future<String?> getPassword() async {
    return _preferences.getString('password');
  }

  Future<String?> getToken() async {
    return _preferences.getString('token');
  }

  Future<String?> getFCMToken() async {
    return _preferences.getString('fcmToken');
  }

  Future<void> setFCMToken(String fcmToken) async {
    print("FCM Token Saved in Prefs:\n $fcmToken");
    await _preferences.setString('fcmToken', fcmToken);
  }

  Future<String?> getRefreshToken() async {
    return _preferences.getString('refreshToken');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
