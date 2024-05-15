part of 'beneficiary_bloc.dart';

@immutable
sealed class BeneficiaryEvent {}

final class OnAddBeneficiary extends BeneficiaryEvent {
  final BeneficiaryParams params;

  OnAddBeneficiary({required this.params});
}

final class OnDeleteBeneficiary extends BeneficiaryEvent {
  final String id;

  OnDeleteBeneficiary({required this.id});
}

final class OnGetBeneficiary extends BeneficiaryEvent {
  final String id;

  OnGetBeneficiary({required this.id});
}

final class OnGetAllBeneficiaries extends BeneficiaryEvent {}
