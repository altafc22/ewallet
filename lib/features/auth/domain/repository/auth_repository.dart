import 'dart:async';

import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../usecases/user_login.dart';
import '../usecases/user_register.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthEntity>> register(RegisterParams params);

  Future<Either<Failure, AuthEntity>> login(LoginParams params);
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, AuthEntity>> currentUser();
  Future<Either<Failure, AuthEntity>> checkAuth();
}
