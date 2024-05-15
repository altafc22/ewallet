import 'dart:convert';

import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/features/transaction/data/model/transaction_model.dart';
import 'package:ewallet/features/transaction/domain/usecase/recharge_wallet.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';

import '../../../../core/error/error_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';

abstract interface class TransactionRemoteDataSource {
  Future<TransactionModel> recharge(RechageParams param);
  Future<TransactionModel> topup(TopUpParams param);
  Future<List<TransactionModel>> getAll();
  Future<List<TransactionModel>> getAllTransactionByBeneficiary(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient api;
  TransactionRemoteDataSourceImpl(this.api);

  @override
  Future<List<TransactionModel>> getAll() async {
    try {
      var response = await api.get(ApiConfig.transactions);

      if (response.statusCode.success) {
        var jsonData = jsonDecode(response.body)['transactions'];
        List<TransactionModel> transactions = [];
        for (var item in jsonData) {
          transactions.add(TransactionModel.fromJson(item));
        }
        return transactions;
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.message ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      printError(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactionByBeneficiary(
      String id) async {
    try {
      var response = await api.get("${ApiConfig.transactionByBeneficiary}/$id");

      if (response.statusCode.success) {
        List<dynamic> jsonData = jsonDecode(response.body)['transactions'];
        List<TransactionModel> transactions = jsonData.map((item) {
          return TransactionModel.fromJson(item);
        }).toList();
        return transactions;
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
  Future<TransactionModel> recharge(RechageParams param) async {
    try {
      var response = await api.post(ApiConfig.recharge, body: param.toJson());

      if (response.statusCode.success) {
        Map<String, dynamic> map = jsonDecode(response.body);

        return TransactionModel.fromJson(map['transaction']);
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
  Future<TransactionModel> topup(TopUpParams param) async {
    try {
      var response = await api.post(ApiConfig.topup, body: param.toJson());

      if (response.statusCode.success) {
        Map<String, dynamic> map = jsonDecode(response.body);

        return TransactionModel.fromJson(map['transaction']);
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
