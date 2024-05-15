import 'package:ewallet/core/app_asset.dart';
import 'package:ewallet/core/app_dimens.dart';
import 'package:ewallet/core/app_string.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/common/widget/generic_button.dart';
import 'package:ewallet/core/common/widget/text_field.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/features/auth/domain/usecases/user_login.dart';
import 'package:ewallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:ewallet/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/common/utils/show_toast.dart';
import '../../../../core/common/widget/generic_appbar.dart';
import '../../../../core/common/widget/loader.dart';
import '../../../../core/app_style.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passpwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.primary,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAsset.bgPattern,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 72,
                            width: 72,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppPallete.white),
                              child: Image.asset(
                                AppAsset.appIcon,
                                color: AppPallete.primary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppString.appName,
                            style: headLine1.copyWith(
                                fontSize: 24, color: AppPallete.white),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      signInForm(),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passpwordController.dispose();
    super.dispose();
  }

  Widget submitButton() {
    return GenericButton(
      buttonText: "Sign In",
      onPressed: () {
        if (formKey.currentState!.validate()) {
          var param = LoginParams(
              username: emailController.text.trim(),
              password: passpwordController.text.trim());
          context.read<LoginCubit>().userLogin(param);
          _clearForm();
        }
      },
    );
  }

  Widget signInForm() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        printInfo(state);
        if (state is LoginFailed) {
          showToast(state.message);
        }
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
              context, HomePage.route(), (route) => false);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppPallete.white,
                  borderRadius: BorderRadius.circular(AppDimens.cardRadius)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Sign In",
                            style: headLine1,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyTextField(
                        hintText: 'Email',
                        icon: Iconsax.user,
                        controller: emailController,
                        onValidate: (value) {},
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        hintText: 'Password',
                        icon: Iconsax.lock,
                        controller: passpwordController,
                        passwordField: true,
                        onValidate: (value) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      submitButton(),
                      const SizedBox(
                        height: 15,
                      ),
                      state is LoginLoading ? const Loader() : const SizedBox(),
                      state is LoginLoading
                          ? const SizedBox(
                              height: 15,
                            )
                          : const SizedBox(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, SignUpPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: headLine6,
                              children: [
                                TextSpan(
                                    text: "Sign Up",
                                    style: headLine6.copyWith(
                                        color: AppPallete.primary,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    formKey.currentState?.reset();
    emailController.clear();
    passpwordController.clear();
  }
}
