import 'user_entity.dart';

class AuthEntity {
  final UserEntity user;
  final String accessToken;
  AuthEntity({
    required this.user,
    required this.accessToken,
  });
}
