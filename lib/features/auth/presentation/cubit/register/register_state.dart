part of 'register_cubit.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterFailed extends RegisterState {
  final String message;
  RegisterFailed(this.message);
}

class RegisterSuccess extends RegisterState {
  final AuthEntity user;
  RegisterSuccess(this.user);
}
