import 'dart:convert';

import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/error/sucess_response.dart';
import 'package:ewallet/features/beneficiaries/data/model/beneficiaries_model.dart';
import 'package:ewallet/features/beneficiaries/data/model/beneficiary_model.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';

import '../../../../core/error/error_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<BeneficiaryModel> addBeneficiary(BeneficiaryParams param);
  Future<List<BeneficiaryModel>> getBeneficiaries();
  Future<BeneficiaryModel> getBeneficiary(String id);
  Future<String> deleteBeneficiary(String id);
}

class BeneficiaryRemoteDataSourceImpl implements BeneficiaryRemoteDataSource {
  final ApiClient api;
  BeneficiaryRemoteDataSourceImpl(this.api);

  @override
  Future<BeneficiaryModel> addBeneficiary(BeneficiaryParams param) async {
    try {
      var response =
          await api.post(ApiConfig.beneficiaries, body: param.toJson());
      print(response.body);
      if (response.statusCode.success) {
        return BeneficiaryModel.fromJson(jsonDecode(response.body));
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
  Future<BeneficiaryModel> getBeneficiary(String id) async {
    try {
      var response = await api.get(
        "${ApiConfig.beneficiaries}/$id",
      );

      if (response.statusCode.success) {
        var data = jsonDecode(response.body)['beneficiary'];
        return BeneficiaryModel.fromJson(data);
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
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    try {
      var response = await api.get(
        "${ApiConfig.beneficiaries}/",
      );

      if (response.statusCode.success) {
        var result = BeneficiariesModel.fromJson(jsonDecode(response.body));
        return result.beneficiaries;
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
  Future<String> deleteBeneficiary(String id) async {
    try {
      var response = await api.delete(
        "${ApiConfig.beneficiaries}/$id",
      );

      if (response.statusCode.success) {
        var successModel = SucessResponse.fromJson(jsonDecode(response.body));
        return successModel.message ?? 'Account deleted sucessfully';
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
}
