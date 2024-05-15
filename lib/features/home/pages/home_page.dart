import 'package:ewallet/core/app_asset.dart';
import 'package:ewallet/core/app_dimens.dart';
import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/app_style.dart';
import 'package:ewallet/core/common/cubits/auth/auth_state.dart';
import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:ewallet/core/common/utils/session_manager.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/auth_guard.dart';

import 'package:ewallet/core/common/widget/rounded_card.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/core/common/cubits/auth/auth_cubit.dart';
import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/presentation/pages/account_detail_page.dart';
import 'package:ewallet/features/beneficiaries/presentation/pages/account_list_page.dart';
import 'package:ewallet/features/home/widget/action_card.dart';
import 'package:ewallet/features/profile/presentation/pages/profile_page.dart';
import 'package:ewallet/features/transaction/presentation/pages/recharge_wallet_page.dart';
import 'package:ewallet/features/transaction/presentation/pages/transaction_list_page.dart';
import 'package:ewallet/injection_container.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../core/app_string.dart';
import '../../../core/common/widget/confirmation_dialog.dart';
import '../../../core/common/widget/rounded_container.dart';
import '../../beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import '../../beneficiaries/presentation/pages/account_topup_page.dart';
import '../widget/balance_viewer.dart';
import '../widget/beneficiary_card.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int switcherIndex = 0;

  AuthEntity? sessionUser;

  @override
  void initState() {
    super.initState();
    _getSession();
  }

  _getSession() async {
    sessionUser = await serviceLocator<SessionManager>().getSession();
    _fetchAllBenefitiaries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: AppPallete.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RoundedCard(
                        height: 120,
                        child: ActionCard(
                          label: "Recharge Wallet",
                          icon: FontAwesomeIcons.wallet,
                          color: AppPallete.primary,
                          onPressed: () {
                            Navigator.push(context, RechargeWalletPage.route())
                                .then((_) {
                              context.read<AuthCubit>().currentUser();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: RoundedCard(
                        height: 120,
                        width: 50,
                        child: ActionCard(
                          label: "Topup Sim",
                          icon: FontAwesomeIcons.simCard,
                          color: AppPallete.purple,
                          onPressed: () {
                            _openAccountPage();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _beneficiaryList()
            ],
          ),
        ),
      ),
    );
  }

  Widget iconButton({
    required String label,
    required VoidCallback onClick,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedContainer(
              height: 40,
              width: 40,
              color: color,
              radius: 8,
              child: Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocConsumer<AuthCubit, AuthState> _header() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthData) {
          setState(() {
            sessionUser = state.user;
          });
        }
        if (state is AuthFailed) {
          showToast(state.message);
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 300,
          child: Stack(
            children: [
              Container(
                height: 240,
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
                        AppAsset.headerBg,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimens.scaffoldPadding),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 42,
                                  width: 42,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
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
                                  width: 5,
                                ),
                                Text(
                                  AppString.appName,
                                  style: headLine4.copyWith(
                                      fontSize: 16, color: AppPallete.white),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    _showLogoutDialog();
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(128),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        FontAwesomeIcons.signOut,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Hi ${sessionUser?.user.name?.toCapital}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppPallete.white)),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    BalanceViewer(
                                      balance:
                                          "${sessionUser?.user.balance} AED",
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconButton(
                            label: "Accounts",
                            onClick: () {
                              _openAccountPage();
                            },
                            color: AppPallete.purple,
                            icon: FontAwesomeIcons.phone),
                        iconButton(
                            label: "Transactions",
                            onClick: () {
                              Navigator.push(
                                      context, TransactionListPage.route())
                                  .then((_) {
                                context.read<AuthCubit>().currentUser();
                              });
                            },
                            color: AppPallete.orange,
                            icon: FontAwesomeIcons.wallet),
                        iconButton(
                            label: "Profile",
                            onClick: () {
                              if (sessionUser != null) {
                                Navigator.push(
                                    context, ProfilePage.route(sessionUser!));
                              }
                            },
                            color: AppPallete.green,
                            icon: FontAwesomeIcons.solidUser)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
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

  _openAccountPage() {
    Navigator.push(context, AccountPage.route()).then((_) {});
  }

  _beneficiaryList() {
    return BlocConsumer<BeneficiaryBloc, BeneficiaryState>(
      listener: (context, state) {
        if (state is BeneficiaryFailure) {
          showToast(state.message);
        }
        if (state is BeneficiarySuccess) {
          _fetchAllBenefitiaries();
        }
        if (state is BeneficiariesSuccess) {
          setState(() {
            beneficiaryItems = state.items;
          });
        }
      },
      builder: (context, state) {
        if (state is BeneficiaryLoading) {
          return const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BeneficiaryCardShimmer(),
                  BeneficiaryCardShimmer(),
                  BeneficiaryCardShimmer()
                ],
              ));
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            children: _getBeneficiaryItems(),
          ),
        );
      },
    );
  }

  List<BeneficiaryEntity> beneficiaryItems = [];
  List<Widget> _getBeneficiaryItems() {
    bool itemsLessThan3 = beneficiaryItems.length < 3;
    return beneficiaryItems.asMap().entries.map((entry) {
      final item = entry.value;
      return BeneficiaryCard(
        item: item,
        onButtonClick: (item) {
          Navigator.push(context, AccountTopUpPage.route(item)).then((_) {
            _fetchAllBenefitiaries();
          });
        },
        onCardClick: (item) {
          Navigator.push(context, AccountDetailPage.route(item)).then((value) {
            _fetchAllBenefitiaries();
          });
        },
      );
    }).toList();
  }

  _fetchAllBenefitiaries() {
    context.read<BeneficiaryBloc>().add(OnGetAllBeneficiaries());
  }
}
