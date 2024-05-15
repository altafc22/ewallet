// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/usecase/usecase.dart';

class UserLogin implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository authRepository;
  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    var response = await authRepository.login(params);
    return response;
  }
}

class LoginParams {
  final String username;
  final String password;
  LoginParams({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  factory LoginParams.fromMap(Map<String, dynamic> map) {
    return LoginParams(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginParams.fromJson(String source) =>
      LoginParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
