import 'package:ewallet/core/common/entities/transaction/transasction_entity.dart';
import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/features/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:ewallet/features/transaction/domain/repository/transaction_repository.dart';
import 'package:ewallet/features/transaction/domain/usecase/recharge_wallet.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/app_string.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasource/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  TransactionRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.connectionChecker});

  @override
  Future<Either<Failure, TransactionEntity>> recharge(
      RechageParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.recharge(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> topup(TopUpParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.topup(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAll() async {
    try {
      if (!await connectionChecker.isConnected) {
        final items = localDataSource.getAll();
        return Right(items);
      }

      var result = await remoteDataSource.getAll();
      localDataSource.insert(items: result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>>
      getAllTransactionByBeneficiary(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.getAllTransactionByBeneficiary(id);

      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
