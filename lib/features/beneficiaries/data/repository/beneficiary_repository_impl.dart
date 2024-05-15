import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/core/network/connection_checker.dart';
import 'package:ewallet/features/beneficiaries/data/datasources/beneficiary_remote_datasource.dart';
import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/app_string.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repository/beneficiary_repository.dart';
import '../datasources/beneficiary_local_datasource.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final BeneficiaryRemoteDataSource remoteDataSource;
  final BeneficiaryLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  BeneficiaryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, BeneficiaryEntity>> add(
      BeneficiaryParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.addBeneficiary(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> delete(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.deleteBeneficiary(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, BeneficiaryEntity>> get(String id) async {
    try {
      var result = await remoteDataSource.getBeneficiary(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BeneficiaryEntity>>> getAll() async {
    try {
      if (!await connectionChecker.isConnected) {
        final items = localDataSource.getAll();
        return Right(items);
      }
      var result = await remoteDataSource.getBeneficiaries();
      localDataSource.insert(items: result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
