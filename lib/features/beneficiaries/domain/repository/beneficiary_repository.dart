import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

abstract interface class BeneficiaryRepository {
  Future<Either<Failure, BeneficiaryEntity>> add(BeneficiaryParams params);
  Future<Either<Failure, BeneficiaryEntity>> get(String id);
  Future<Either<Failure, List<BeneficiaryEntity>>> getAll();
  Future<Either<Failure, String>> delete(String id);
}
