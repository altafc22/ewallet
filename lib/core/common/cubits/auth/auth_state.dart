import '../../entities/auth/auth_entity.dart';

class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthData extends AuthState {
  final AuthEntity user;
  const AuthData({required this.user});
}

final class AuthFailed extends AuthState {
  final String message;
  const AuthFailed(this.message);
}

final class AuthLogoutSuccess extends AuthState {}

final class AuthLogoutFailed extends AuthState {
  final String message;
  const AuthLogoutFailed(this.message);
}
