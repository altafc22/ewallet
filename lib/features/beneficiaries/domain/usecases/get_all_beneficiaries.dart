import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

class GetAllBeneficiaries
    implements UseCase<List<BeneficiaryEntity>, NoParams> {
  final BeneficiaryRepository _repository;
  GetAllBeneficiaries(this._repository);

  @override
  Future<Either<Failure, List<BeneficiaryEntity>>> call(NoParams params) async {
    return await _repository.getAll();
  }
}
