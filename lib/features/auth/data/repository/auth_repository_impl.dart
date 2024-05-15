import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/core/common/utils/session_manager.dart';
import 'package:ewallet/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ewallet/features/auth/data/model/auth_model.dart';
import 'package:ewallet/features/auth/domain/repository/auth_repository.dart';
import 'package:ewallet/injection_container.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/app_string.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_register.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ConnectionChecker connectionChecker;
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(
      {required this.connectionChecker, required this.remoteDataSource});

  final sessionManager = serviceLocator<SessionManager>();

  @override
  Future<Either<Failure, AuthModel>> login(LoginParams params) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.login(params);
      sessionManager.saveSession(result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> register(RegisterParams params) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.register(params);
      sessionManager.saveSession(result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> currentUser() async {
    try {
      final isConnected = await (connectionChecker.isConnected);
      printInfo("internet $isConnected ");
      if (!await (connectionChecker.isConnected)) {
        final session = await remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('Please sign in'));
        }
        return right(session);
      }

      var result = await remoteDataSource.getCurrentUserData();

      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.logout();
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> checkAuth() async {
    final session = await remoteDataSource.currentUserSession;
    if (session == null) {
      return left(Failure('Please sign in'));
    }
    return right(session);
  }
}
