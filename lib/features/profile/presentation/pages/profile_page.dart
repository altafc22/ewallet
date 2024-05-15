import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/cubits/auth/auth_cubit.dart';
import 'package:ewallet/core/common/cubits/auth/auth_state.dart';
import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:ewallet/core/common/widget/auth_guard.dart';
import 'package:ewallet/core/common/widget/confirmation_dialog.dart';
import 'package:ewallet/core/common/widget/generic_appbar.dart';
import 'package:ewallet/core/common/widget/generic_button.dart';
import 'package:ewallet/features/transaction/presentation/pages/recharge_wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/app_asset.dart';
import '../../../../core/app_dimens.dart';
import '../../../../core/app_string.dart';
import '../../../../core/common/utils/show_toast.dart';
import '../../../../core/common/widget/profile_field.dart';
import '../../../../core/common/widget/rounded_card.dart';
import '../../../../core/theme/pallete.dart';

class ProfilePage extends StatefulWidget {
  static route(AuthEntity user) => MaterialPageRoute(
      builder: (context) => ProfilePage(
            user: user,
          ));

  final AuthEntity user;
  const ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthEntity session;
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().currentUser();
    setState(() {
      session = widget.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Profile',
          backgroundColor: AppPallete.primary,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getHeader(),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthData) {
                  session = state.user;
                }
              },
              builder: (context, state) {
                return Container();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  field(
                    FontAwesomeIcons.solidUser,
                    "ID",
                    "${session.user.id?.toUpperCase()}",
                  ),
                  field(
                    FontAwesomeIcons.solidUser,
                    "Username (email)",
                    "${session.user.username}",
                  ),
                  field(
                    FontAwesomeIcons.phone,
                    "Phone number",
                    "${session.user.phone}",
                  ),
                  field(
                    FontAwesomeIcons.certificate,
                    "Verified User",
                    session.user.isVerified! ? 'Yes' : 'No',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: GenericButton(
                  buttonText: "Logout",
                  onPressed: () {
                    _showLogoutDialog();
                  }),
            )
          ],
        ),
      ),
    );
  }

  _getHeader() {
    return SizedBox(
      height: 175,
      child: Stack(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
                color: AppPallete.primary,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    height: 150,
                    AppAsset.headerBg,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDimens.scaffoldPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text("${session.user.name?.toCapital}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppPallete.white)),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.scaffoldPadding,
              ),
              child: RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppPallete.primary.withAlpha(100),
                        child: const Icon(
                          FontAwesomeIcons.wallet,
                          color: AppPallete.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your wallet balance",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black38,
                            ),
                          ),
                          Text(
                            "${session.user.balance?.formatAmount("AED ")}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, RechargeWalletPage.route())
                              .then((balance) {
                            context.read<AuthCubit>().currentUser();
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppPallete.green.withAlpha(100),
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            color: AppPallete.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showLogoutDialog() async {
    var isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: "Confirmation",
            message: "Do you really want to sign out?",
            icon: FontAwesomeIcons.exclamation,
            onConfirm: () {
              context.read<AuthCubit>().userLogout();
            },
          );
        },
      );
    } else {
      showToast(AppString.noInternetConnection);
    }
  }
}
