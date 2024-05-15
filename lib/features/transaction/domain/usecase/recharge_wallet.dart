import 'dart:convert';

import 'package:ewallet/core/common/entities/transaction/transasction_entity.dart';
import 'package:ewallet/features/transaction/domain/repository/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

class RechageWallet implements UseCase<TransactionEntity, RechageParams> {
  final TransactionRepository _repository;
  RechageWallet(this._repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(RechageParams params) async {
    return await _repository.recharge(params);
  }
}

class RechageParams {
  final String description;
  final num amount;
  RechageParams({
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'amount': amount,
    };
  }

  factory RechageParams.fromMap(Map<String, dynamic> map) {
    return RechageParams(
      description: map['description'] as String,
      amount: map['amount'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory RechageParams.fromJson(String source) =>
      RechageParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
