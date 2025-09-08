import 'dart:async';

import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';


class AuthManager {
  final UserPreference _localPref;
  final StreamController<String?> _tokenStreamController = StreamController();
  Stream<String?> get tokenStream => _tokenStreamController.stream;

  AuthManager({
    required UserPreference localPref,
  }) : _localPref = localPref {
    init();
  }

  void init() async {
    var token = await _localPref.getToken();
    addToken(token);
  }

  void addToken(String? token) {
    if (token == null) {
      Future.delayed(
          const Duration(seconds: 2), () => _tokenStreamController.add(null));
    } else {
      // handle saving token
    }
  }

  void addValidToken(String? token) {
    _tokenStreamController.add(token);
  }

  void dispose() {
    _tokenStreamController.close();
  }
}
