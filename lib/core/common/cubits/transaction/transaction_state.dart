part of 'transaction_cubit.dart';

@immutable
sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class RechargeTransactionSuccess extends TransactionState {
  final TransactionEntity transaction;
  RechargeTransactionSuccess(this.transaction);
}

final class TopUpTransactionSuccess extends TransactionState {
  final TransactionEntity transaction;
  TopUpTransactionSuccess(this.transaction);
}

final class TransactionFailure extends TransactionState {
  final String message;
  TransactionFailure(this.message);
}

final class TransactionSuccess extends TransactionState {}

final class GetTransactionSuccess extends TransactionState {
  final List<TransactionEntity> transactions;
  GetTransactionSuccess(this.transactions);
}
