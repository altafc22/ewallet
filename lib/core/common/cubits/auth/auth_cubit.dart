import 'package:ewallet/core/common/usecase/usecase.dart';
import 'package:ewallet/features/auth/domain/usecases/check_auth.dart';
import 'package:ewallet/core/common/cubits/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/log_utils.dart';
import '../../../../features/auth/domain/usecases/current_user.dart';
import '../../../../features/auth/domain/usecases/logout_user.dart';

class AuthCubit extends Cubit<AuthState> {
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final CheckAuth _checkAuth;

  AuthCubit({
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required CheckAuth checkAuth,
  })  : _currentUser = currentUser,
        _userLogout = userLogout,
        _checkAuth = checkAuth,
        super(AuthInitial()) {
    authCheck();
  }

  void authCheck() async {
    final res = await _checkAuth.call(NoParams());

    res.fold(
        (l) => emit(AuthFailed(l.message)), (r) => emit(AuthData(user: r)));
  }

  void currentUser() async {
    final res = await _currentUser.call(NoParams());

    res.fold(
        (l) => emit(AuthFailed(l.message)), (r) => emit(AuthData(user: r)));
  }

  void userLogout() async {
    printInfo("Logout user");
    emit(AuthLoading());
    final res = await _userLogout(NoParams());
    print("userLogout: $res");
    res.fold(
      (l) => emit(AuthLogoutFailed(l.message)),
      (r) {
        emit(AuthInitial());
      },
    );
  }
}
