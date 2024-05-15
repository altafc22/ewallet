import 'package:ewallet/features/auth/data/model/user_model.dart';
import 'package:ewallet/core/common/entities/auth/auth_entity.dart';

class AuthModel extends AuthEntity {
  final UserModel user;
  final String accessToken;

  AuthModel({
    required this.user,
    required this.accessToken,
  }) : super(
          user: user,
          accessToken: accessToken,
        );

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json["user"]),
      accessToken: json["accessToken"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
      };
}
