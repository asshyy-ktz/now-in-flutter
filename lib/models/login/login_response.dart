class LoginResponse {
  final String? token;
  final String? userId;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? employeeId;

  LoginResponse({
    this.token,
    this.userId,
    this.userName,
    this.firstName,
    this.lastName,
    this.employeeId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['Token'],
      userId: json['UserId'],
      userName: json['UserName'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      employeeId: json['EmployeeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Token': token,
      'UserId': userId,
      'UserName': userName,
      'FirstName': firstName,
      'LastName': lastName,
      'EmployeeId': employeeId,
    };
  }
}
