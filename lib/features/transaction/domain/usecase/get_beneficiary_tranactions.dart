import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/transaction/transasction_entity.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repository/transaction_repository.dart';

class GetBeneficiaryTransactions
    implements UseCase<List<TransactionEntity>, String> {
  final TransactionRepository _repository;
  GetBeneficiaryTransactions(this._repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(String id) async {
    return await _repository.getAllTransactionByBeneficiary(id);
  }
}
