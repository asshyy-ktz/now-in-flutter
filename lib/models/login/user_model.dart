class UserModel {
  String? token;
  bool? isLogin;

  UserModel({token, isLogin});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    isLogin = json['isLogin'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['isLogin'] = token;
    return data;
  }
}
