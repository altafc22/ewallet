import 'dart:convert';

import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

class AddBeneficiary implements UseCase<BeneficiaryEntity, BeneficiaryParams> {
  final BeneficiaryRepository _repository;
  AddBeneficiary(this._repository);

  @override
  Future<Either<Failure, BeneficiaryEntity>> call(
      BeneficiaryParams params) async {
    return await _repository.add(params);
  }
}

class BeneficiaryParams {
  final String nickname;
  final String phoneNumber;
  BeneficiaryParams({
    required this.nickname,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickname': nickname,
      'phoneNumber': phoneNumber,
    };
  }

  factory BeneficiaryParams.fromMap(Map<String, dynamic> map) {
    return BeneficiaryParams(
      nickname: map['username'] as String,
      phoneNumber: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BeneficiaryParams.fromJson(String source) =>
      BeneficiaryParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
