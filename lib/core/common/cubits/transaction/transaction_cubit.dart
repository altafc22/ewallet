import 'package:ewallet/core/common/entities/transaction/transasction_entity.dart';
import 'package:ewallet/core/common/usecase/usecase.dart';
import 'package:ewallet/features/transaction/domain/usecase/get_all_transactions.dart';
import 'package:ewallet/features/transaction/domain/usecase/get_beneficiary_tranactions.dart';
import 'package:ewallet/features/transaction/domain/usecase/recharge_wallet.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/log_utils.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final RechageWallet rechargeWalletUsecase;
  final TopUpBeneficiary topUpBeneficiaryUsecase;
  final GetAllTransactions getAllTransactionsUseCase;
  final GetBeneficiaryTransactions getBeneficiaryTransactionsUseCase;

  TransactionCubit(
      {required this.rechargeWalletUsecase,
      required this.topUpBeneficiaryUsecase,
      required this.getAllTransactionsUseCase,
      required this.getBeneficiaryTransactionsUseCase})
      : super(TransactionInitial());

  void topUpBenefciary(TopUpParams params) async {
    emit(TransactionLoading());
    final res = await topUpBeneficiaryUsecase.call(params);
    res.fold((l) => emit(TransactionFailure(l.message)),
        (r) => emit(TopUpTransactionSuccess(r)));
  }

  void rechargeWallet(RechageParams params) async {
    emit(TransactionLoading());
    final res = await rechargeWalletUsecase.call(params);
    res.fold((l) => emit(TransactionFailure(l.message)),
        (r) => emit(RechargeTransactionSuccess(r)));
  }

  void getAllTransactions() async {
    emit(TransactionLoading());
    printInfo("getAllTransactions");
    final res = await getAllTransactionsUseCase.call(NoParams());
    res.fold((l) => emit(TransactionFailure(l.message)),
        (r) => emit(GetTransactionSuccess(r)));
  }

  void getBeneficiaryTransactions(String id) async {
    emit(TransactionLoading());
    final res = await getBeneficiaryTransactionsUseCase.call(id);

    res.fold((l) => emit(TransactionFailure(l.message)),
        (r) => emit(GetTransactionSuccess(r)));
  }
}
