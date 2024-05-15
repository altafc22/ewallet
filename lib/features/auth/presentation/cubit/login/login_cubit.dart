import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:ewallet/core/common/cubits/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/user_login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthCubit _authCubit;
  final UserLogin _userLogin;

  LoginCubit({
    required UserLogin userLogin,
    required AuthCubit authCubit,
  })  : _userLogin = userLogin,
        _authCubit = authCubit,
        super(LoginInitial());

  void userLogin(LoginParams params) async {
    emit(LoginLoading());
    final res = await _userLogin(params);
    res.fold(
      (l) => emit(LoginFailed(l.message)),
      (r) {
        emit(LoginSuccess(r));
        _authCubit.currentUser();
      },
    );
  }
}
