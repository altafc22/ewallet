import 'package:ewallet/core/common/usecase/usecase.dart';
import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/delete_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/get_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/get_all_beneficiaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'beneficiary_event.dart';
part 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final AddBeneficiary addBeneficiary;
  final GetBeneficiary getBeneficiary;
  final GetAllBeneficiaries getAllBeneficiaries;
  final DeleteBeneficiary deleteBeneficiary;

  BeneficiaryBloc(
      {required this.addBeneficiary,
      required this.getBeneficiary,
      required this.getAllBeneficiaries,
      required this.deleteBeneficiary})
      : super(BeneficiaryInitial()) {
    on<BeneficiaryEvent>((event, emit) => emit(BeneficiaryLoading()));
    on<OnAddBeneficiary>(_onAddBeneficiary);
    on<OnGetBeneficiary>(_onGetBeneficiary);
    on<OnGetAllBeneficiaries>(_onGetAllBeneficiaries);
    on<OnDeleteBeneficiary>(_onDeleteBeneficiary);
  }

  void _onAddBeneficiary(
      OnAddBeneficiary event, Emitter<BeneficiaryState> state) async {
    final res = await addBeneficiary.call(event.params);
    res.fold((l) => emit(BeneficiaryFailure(l.message)),
        (r) => emit(BeneficiarySuccess()));
  }

  void _onGetBeneficiary(
      OnGetBeneficiary event, Emitter<BeneficiaryState> state) async {
    final res = await getBeneficiary.call(event.id);
    res.fold((l) => emit(BeneficiaryFailure(l.message)),
        (r) => emit(GetBeneficiarySuccess(r)));
  }

  void _onGetAllBeneficiaries(
      OnGetAllBeneficiaries event, Emitter<BeneficiaryState> state) async {
    final res = await getAllBeneficiaries.call(NoParams());
    res.fold((l) => emit(BeneficiaryFailure(l.message)),
        (r) => emit(BeneficiariesSuccess(r)));
  }

  void _onDeleteBeneficiary(
      OnDeleteBeneficiary event, Emitter<BeneficiaryState> state) async {
    final res = await deleteBeneficiary.call(event.id);
    res.fold((l) => emit(BeneficiaryFailure(l.message)),
        (r) => emit(BeneficiarySuccess()));
  }
}
