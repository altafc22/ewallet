part of 'beneficiary_bloc.dart';

sealed class BeneficiaryState {}

final class BeneficiaryInitial extends BeneficiaryState {}

final class BeneficiaryLoading extends BeneficiaryState {}

final class BeneficiaryFailure extends BeneficiaryState {
  final String message;
  BeneficiaryFailure(this.message);
}

final class BeneficiarySuccess extends BeneficiaryState {}

final class GetBeneficiarySuccess extends BeneficiaryState {
  final BeneficiaryEntity beneficiary;
  GetBeneficiarySuccess(this.beneficiary);
}

final class BeneficiariesSuccess extends BeneficiaryState {
  final List<BeneficiaryEntity> items;
  BeneficiariesSuccess(this.items);
}
