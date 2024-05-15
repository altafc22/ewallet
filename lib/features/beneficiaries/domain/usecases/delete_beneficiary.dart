import 'package:ewallet/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

class DeleteBeneficiary implements UseCase<String, String> {
  final BeneficiaryRepository _repository;
  DeleteBeneficiary(this._repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await _repository.delete(params);
  }
}
