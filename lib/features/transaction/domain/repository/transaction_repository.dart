import 'package:ewallet/core/common/entities/transaction/transasction_entity.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../usecase/recharge_wallet.dart';

abstract interface class TransactionRepository {
  Future<Either<Failure, TransactionEntity>> recharge(RechageParams params);
  Future<Either<Failure, TransactionEntity>> topup(TopUpParams params);
  Future<Either<Failure, List<TransactionEntity>>> getAll();
  Future<Either<Failure, List<TransactionEntity>>>
      getAllTransactionByBeneficiary(String id);
}
