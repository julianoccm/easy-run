import 'package:frontend/entities/returns/user_entity_return.dart';

class LoginEntityReturn {
  final String accessToken;
  final UserEntityReturn userEntityReturn;

  const LoginEntityReturn(
      {required this.accessToken, required this.userEntityReturn});

  factory LoginEntityReturn.fromJson(Map<String, dynamic> json) {
    return LoginEntityReturn(
        accessToken: json['access_token'],
        userEntityReturn: UserEntityReturn.fromJson(json['user']));
  }
}
