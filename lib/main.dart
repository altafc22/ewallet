import 'package:ewallet/core/app_string.dart';

import 'package:ewallet/core/common/cubits/transaction/transaction_cubit.dart';
import 'package:ewallet/core/common/cubits/auth/auth_cubit.dart';
import 'package:ewallet/core/common/cubits/auth/auth_state.dart';
import 'package:ewallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:ewallet/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:ewallet/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ewallet/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:ewallet/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme.dart';
import 'features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthCubit>()),
      BlocProvider(create: (_) => serviceLocator<LoginCubit>()),
      BlocProvider(create: (_) => serviceLocator<RegisterCubit>()),
      BlocProvider(create: (_) => serviceLocator<BeneficiaryBloc>()),
      BlocProvider(create: (_) => serviceLocator<TransactionCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().authCheck();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme: AppTheme.lightTheme(context),
      home: BlocSelector<AuthCubit, AuthState, bool>(
        selector: (state) {
          return state is AuthData;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const HomePage();
          }
          return const SignInPage();
        },
      ),
    );
  }
}
