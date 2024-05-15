import 'dart:async';
import 'dart:convert';

import 'package:ewallet/core/common/utils/session_manager.dart';
import 'package:ewallet/core/error/error_response.dart';
import 'package:ewallet/core/network/api_config.dart';
import 'package:ewallet/core/network/api_client.dart';
import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/features/auth/data/model/auth_model.dart';

import 'package:ewallet/features/auth/domain/usecases/user_login.dart';
import 'package:ewallet/injection_container.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/user_register.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthModel?> get currentUserSession;

  Future<AuthModel> register(RegisterParams params);
  Future<AuthModel> login(LoginParams params);
  Future<String> logout();
  Future<AuthModel> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;
  AuthRemoteDataSourceImpl(this.api);

  final _sessionManager = serviceLocator<SessionManager>();

  @override
  Future<AuthModel?> get currentUserSession async {
    var session = await _sessionManager.getSession();

    if (session != null) {
      var token = session.accessToken;
      if (!JwtDecoder.isExpired(token)) {
        return session;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Future<AuthModel> login(LoginParams params) async {
    try {
      var response = await api.post(ApiConfig.loginUser, body: params.toJson());

      if (response.statusCode.success) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.message ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthModel> register(RegisterParams params) async {
    try {
      var response =
          await api.post(ApiConfig.registerUser, body: params.toJson());

      if (response.statusCode.success) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.message ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AuthModel> getCurrentUserData() async {
    try {
      var response = await api.get(ApiConfig.profile);

      if (response.statusCode.success) {
        var item = AuthModel.fromJson(jsonDecode(response.body));
        _sessionManager.saveSession(item);
        return item;
      } else if (response.statusCode == 401) {
        throw const ServerException('Please sign in');
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.message ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> logout() async {
    try {
      var response = await api.post(ApiConfig.logoutUser);

      if (response.statusCode.success) {
        _sessionManager.clearSession();
        return "Logout successfull";
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.message ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
