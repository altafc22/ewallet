import 'package:ewallet/core/common/cubits/transaction/transaction_cubit.dart';
import 'package:ewallet/core/network/api_client.dart';
import 'package:ewallet/core/network/connection_checker.dart';
import 'package:ewallet/features/auth/domain/usecases/check_auth.dart';
import 'package:ewallet/features/auth/domain/usecases/logout_user.dart';
import 'package:ewallet/core/common/cubits/auth/auth_cubit.dart';
import 'package:ewallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:ewallet/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:ewallet/features/beneficiaries/data/datasources/beneficiary_remote_datasource.dart';
import 'package:ewallet/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/delete_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/get_all_beneficiaries.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/get_beneficiary.dart';
import 'package:ewallet/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ewallet/features/auth/data/repository/auth_repository_impl.dart';
import 'package:ewallet/features/auth/domain/repository/auth_repository.dart';
import 'package:ewallet/features/auth/domain/usecases/current_user.dart';
import 'package:ewallet/features/auth/domain/usecases/user_login.dart';
import 'package:ewallet/features/auth/domain/usecases/user_register.dart';
import 'package:ewallet/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:ewallet/features/transaction/data/datasource/transaction_remote_datasource.dart';
import 'package:ewallet/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:ewallet/features/transaction/domain/repository/transaction_repository.dart';
import 'package:ewallet/features/transaction/domain/usecase/get_all_transactions.dart';
import 'package:ewallet/features/transaction/domain/usecase/get_beneficiary_tranactions.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/utils/session_manager.dart';
import 'core/common/utils/shared_preference.dart';
import 'features/beneficiaries/data/datasources/beneficiary_local_datasource.dart';
import 'features/beneficiaries/data/repository/beneficiary_repository_impl.dart';
import 'features/transaction/data/datasource/transaction_local_datasource.dart';
import 'features/transaction/domain/usecase/recharge_wallet.dart';

final serviceLocator = GetIt.instance;

Future<void> initDi() async {
  await _registerSharePreference();
  await _registerApiClient();
  await _initDb();

  await _initCore();

  _initAuth();
  _initBeneficiary();
  _initTransaction();
}

Future<void> _registerSharePreference() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final SharedPrefsUtil sharedPrefsUtil =
      await SharedPrefsUtil.getInstance(sharedPreferences);
  serviceLocator.registerSingleton<SharedPrefsUtil>(sharedPrefsUtil);

  final sessionManager = SessionManager(sharedPrefsUtil);
  serviceLocator.registerSingleton<SessionManager>(sessionManager);
}

Future<void> _registerApiClient() async {
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
}

_initDb() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  // serviceLocator.registerLazySingleton(
  //   () => Hive.box(name: "beneficiaries"),
  // );
  // serviceLocator.registerLazySingleton(
  //   () => Hive.box(name: "tranactions"),
  // );
}

_initCore() async {
  serviceLocator
      .registerFactory(() => InternetConnection()); // every time new object
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator())); // every time new object
}

_initAuth() {
  serviceLocator
    //datasource
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    //repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        connectionChecker: serviceLocator(),
        remoteDataSource: serviceLocator()))
    // usecases
    ..registerFactory(() => UserRegister(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserLogout(serviceLocator()))
    ..registerFactory(() => CheckAuth(serviceLocator()))
    //bloc
    ..registerLazySingleton(() => AuthCubit(
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
        checkAuth: serviceLocator()))
    ..registerLazySingleton(() => LoginCubit(
          userLogin: serviceLocator(),
          authCubit: serviceLocator(),
        ))
    ..registerLazySingleton(() => RegisterCubit(
          userRegister: serviceLocator(),
          authCubit: serviceLocator(),
        ));
}

_initBeneficiary() {
  serviceLocator
    //datasource
    ..registerFactory<BeneficiaryRemoteDataSource>(
        () => BeneficiaryRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BeneficiaryLocalDataSource>(
        () => BeneficiaryLocalDataSourceImpl(Hive.box(name: "beneficiaries")))
    //repository
    ..registerFactory<BeneficiaryRepository>(() => BeneficiaryRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => AddBeneficiary(serviceLocator()))
    ..registerFactory(() => GetBeneficiary(serviceLocator()))
    ..registerFactory(() => GetAllBeneficiaries(serviceLocator()))
    ..registerFactory(() => DeleteBeneficiary(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => BeneficiaryBloc(
          addBeneficiary: serviceLocator(),
          getBeneficiary: serviceLocator(),
          getAllBeneficiaries: serviceLocator(),
          deleteBeneficiary: serviceLocator()),
    );
}

_initTransaction() {
  serviceLocator
    //datasource
    ..registerFactory<TransactionRemoteDataSource>(
        () => TransactionRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<TransactionLocalDataSource>(
        () => TransactionLocalDataSourceImpl(Hive.box(name: "transaction")))
    //repository
    ..registerFactory<TransactionRepository>(() => TransactionRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => GetAllTransactions(serviceLocator()))
    ..registerFactory(() => GetBeneficiaryTransactions(serviceLocator()))
    ..registerFactory(() => RechageWallet(serviceLocator()))
    ..registerFactory(() => TopUpBeneficiary(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => TransactionCubit(
          getAllTransactionsUseCase: serviceLocator(),
          getBeneficiaryTransactionsUseCase: serviceLocator(),
          rechargeWalletUsecase: serviceLocator(),
          topUpBeneficiaryUsecase: serviceLocator()),
    );
}
