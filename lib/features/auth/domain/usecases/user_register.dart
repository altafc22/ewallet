import 'dart:convert';

import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/usecase/usecase.dart';

class UserRegister implements UseCase<AuthEntity, RegisterParams> {
  final AuthRepository authRepository;
  UserRegister(this.authRepository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) async {
    var response = await authRepository.register(params);
    return response;
  }
}

class RegisterParams {
  final String name;
  final String phone;
  final String username;
  final String password;
  RegisterParams({
    required this.name,
    required this.phone,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'username': username,
      'password': password,
    };
  }

  factory RegisterParams.fromMap(Map<String, dynamic> map) {
    return RegisterParams(
      name: map['name'] as String,
      phone: map['phone'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterParams.fromJson(String source) =>
      RegisterParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
