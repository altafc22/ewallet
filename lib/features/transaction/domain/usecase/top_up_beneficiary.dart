import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/transaction/transasction_entity.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repository/transaction_repository.dart';

class TopUpBeneficiary implements UseCase<TransactionEntity, TopUpParams> {
  final TransactionRepository _repository;
  TopUpBeneficiary(this._repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(TopUpParams params) async {
    return await _repository.topup(params);
  }
}

class TopUpParams {
  final String beneficiaryId;
  final num amount;
  TopUpParams({
    required this.beneficiaryId,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'beneficiaryId': beneficiaryId,
      'amount': amount,
    };
  }

  factory TopUpParams.fromMap(Map<String, dynamic> map) {
    return TopUpParams(
      beneficiaryId: map['beneficiaryId'] as String,
      amount: map['amount'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopUpParams.fromJson(String source) =>
      TopUpParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
