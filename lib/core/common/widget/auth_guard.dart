import 'package:ewallet/core/common/utils/session_manager.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed || state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
              context, SignInPage.route(), (route) => false);
        }
        if (state is AuthLogoutFailed) {
          showToast(state.message);
        }
        if (state is AuthData) {
          print("Balance: ${state.user.user.balance}");
        }
      },
      child: child,
    );
  }
}
