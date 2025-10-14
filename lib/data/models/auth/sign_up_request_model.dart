class SignUpRequestModel {
  final String fullName;
  final String username;
  final String email;
  final String password;

  SignUpRequestModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
