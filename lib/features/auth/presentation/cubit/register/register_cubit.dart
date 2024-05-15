import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubits/auth/auth_cubit.dart';
import '../../../../../core/common/entities/auth/auth_entity.dart';
import '../../../domain/usecases/user_register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserRegister _userRegister;
  final AuthCubit _authCubit;
  RegisterCubit({
    required UserRegister userRegister,
    required AuthCubit authCubit,
  })  : _userRegister = userRegister,
        _authCubit = authCubit,
        super(RegisterInitial());

  void userRegister(RegisterParams params) async {
    final res = await _userRegister(params);
    emit(RegisterLoading());

    res.fold(
      (l) => emit(RegisterFailed(l.message)),
      (r) {
        emit(RegisterSuccess(r));
        //_authCubit.currentUser();
      },
    );
  }
}
