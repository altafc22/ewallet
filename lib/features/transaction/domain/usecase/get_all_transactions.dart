import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/transaction/transasction_entity.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repository/transaction_repository.dart';

class GetAllTransactions implements UseCase<List<TransactionEntity>, NoParams> {
  final TransactionRepository _repository;
  GetAllTransactions(this._repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(NoParams params) async {
    return await _repository.getAll();
  }
}
