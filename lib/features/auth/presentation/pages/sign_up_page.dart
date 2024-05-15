import 'package:ewallet/core/app_string.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/generic_button.dart';
import 'package:ewallet/core/common/widget/loader.dart';
import 'package:ewallet/core/common/widget/text_field.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/features/auth/domain/usecases/user_register.dart';
import 'package:ewallet/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:ewallet/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/app_asset.dart';
import '../../../../core/app_dimens.dart';
import '../../../../core/app_style.dart';
import '../../../../core/common/utils/log_utils.dart';
import '../../../../core/common/widget/generic_appbar.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passpwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailed) {}
        if (state is RegisterSuccess) {
          Navigator.pushAndRemoveUntil(
              context, HomePage.route(), (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(
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
                        registerForm(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ))),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passpwordController.dispose();
    super.dispose();
  }

  Widget submitButton() {
    return GenericButton(
      buttonText: "Sign Up",
      onPressed: () {
        if (formKey.currentState!.validate()) {
          var param = RegisterParams(
              name: nameController.text.trim(),
              phone: phoneController.text.trim(),
              username: emailController.text.trim(),
              password: passpwordController.text.trim());
          context.read<RegisterCubit>().userRegister(param);
        }
      },
    );
  }

  Widget registerForm() {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        printInfo(state);
        if (state is RegisterFailed) {
          showToast(state.message);
        }
        if (state is RegisterSuccess) {
          Navigator.pushAndRemoveUntil(
              context, HomePage.route(), (route) => false);
        }
      },
      builder: (context, state) {
        return Container(
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
                        "Sign Up",
                        style: headLine1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MyTextField(
                    hintText: 'Name',
                    icon: Iconsax.user,
                    controller: nameController,
                    inputType: TextInputType.text,
                    maxLength: 30,
                    onValidate: (value) {},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    hintText: 'Phone',
                    icon: Iconsax.call,
                    inputType: TextInputType.phone,
                    maxLength: 10,
                    controller: phoneController,
                    onValidate: (value) {},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    hintText: 'Email',
                    icon: Iconsax.user,
                    inputType: TextInputType.emailAddress,
                    maxLength: 30,
                    controller: emailController,
                    onValidate: (value) {},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    hintText: 'Password',
                    icon: Iconsax.lock,
                    maxLength: 30,
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
                  state is RegisterLoading ? const Loader() : const SizedBox(),
                  state is RegisterLoading
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: headLine6,
                          children: [
                            TextSpan(
                                text: "Sign In",
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
        );
      },
    );
  }
}
