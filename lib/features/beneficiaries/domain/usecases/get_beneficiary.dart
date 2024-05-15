import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

class GetBeneficiary implements UseCase<BeneficiaryEntity, String> {
  final BeneficiaryRepository _repository;
  GetBeneficiary(this._repository);

  @override
  Future<Either<Failure, BeneficiaryEntity>> call(String params) async {
    return await _repository.get(params);
  }
}
