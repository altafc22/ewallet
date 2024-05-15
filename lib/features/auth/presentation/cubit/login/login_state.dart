part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed(this.message);
}

class LoginSuccess extends LoginState {
  final AuthEntity user;
  LoginSuccess(this.user);
}
