import 'dart:convert';
import 'dart:io';
import 'package:ewallet/core/error/exceptions.dart';
import 'package:ewallet/core/network/api_config.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/app_extension.dart';
import 'package:http/http.dart' as http;

import '../../injection_container.dart';
import '../common/utils/session_manager.dart';

enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

class ApiClient {
  late String baseUrl;

  final SessionManager _sessionManager = serviceLocator<SessionManager>();

  final jsonEncoder = const JsonEncoder.withIndent('  ');
  ApiClient() {
    baseUrl = ApiConfig.baseUrl;
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(HttpMethod.get, url, headers: header);
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    try {
      final url = Uri.parse(baseUrl + endpoint);
      final header = await _getHeader();
      var response = await _request(
        HttpMethod.post,
        url,
        headers: header,
        body: body,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, {Object? body}) async {
    final url = Uri.parse(baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.put,
      url,
      body: jsonEncode(body),
      headers: header,
    );
  }

  Future<http.Response> patch(String endpoint, {Object? body}) async {
    final url = Uri.parse(baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.patch,
      url,
      headers: header,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.delete,
      url,
      headers: header,
    );
  }

  _getHeader() async {
    final accessToken = await _sessionManager.getAuthToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<http.Response> _request(HttpMethod method, Uri url,
      {Object? body, Map<String, String>? headers}) async {
    try {
      printInfo('----------------------START----------------------');
      printInfo('method => ${method.name}');
      printInfo('request => $url');

      if (headers != null) {
        final authorization = headers['Authorization'];
        final contentType = headers['ContentType'];
        printInfo('authorization  =>  $authorization');
        printInfo('contentType  =>  $contentType');
      }

      http.Response response;
      switch (method) {
        case HttpMethod.get:
          response = await http.get(url, headers: headers);
          break;
        case HttpMethod.post:
          response = await http.post(url, headers: headers, body: body);
          break;
        case HttpMethod.put:
          response = await http.put(url, headers: headers, body: body);
          break;
        case HttpMethod.patch:
          response = await http.patch(url, headers: headers, body: body);
          break;
        case HttpMethod.delete:
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      printInfo('payload => $body');
      if (response.statusCode.success) {
        printInfo('---------------------RECEIVED--------------------');
        printInfo('method => ${method.name}');
        printInfo('status code => ${response.statusCode}');
        printInfo('contentLength => ${response.contentLength}');

        printInfo('payload => ${response.body}');
      } else {
        printError('---------------------ERROR----------------------');
        printError('method => ${method.name}');
        printError('status code => ${response.statusCode}');
        printError('contentLength => ${response.contentLength}');
        printError('payload => ${response.body}');
      }
      //printInfo('----------------------END-----------------------');

      return response;
    } on SocketException catch (e) {
      printError('---------------------ERROR----------------------');
      printError('error => ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      printError('---------------------ERROR----------------------');
      printError('Exception => ${e.toString()}');
      //printError('----------------------END-----------------------');
      rethrow;
    }
  }
}
