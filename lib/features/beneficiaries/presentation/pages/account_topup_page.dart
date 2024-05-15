import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/cubits/transaction/transaction_cubit.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/auth_guard.dart';
import 'package:ewallet/core/common/widget/generic_button.dart';
import 'package:ewallet/features/transaction/domain/usecase/top_up_beneficiary.dart';
import 'package:ewallet/features/transaction/presentation/pages/transacation_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/common/widget/confirmation_dialog.dart';
import '../../../../core/common/widget/generic_appbar.dart';
import '../../../../core/common/widget/keypad_widget.dart';
import '../../../../core/theme/pallete.dart';
import '../../domain/entitiy/beneficiary_entity.dart';

class AccountTopUpPage extends StatefulWidget {
  static route(BeneficiaryEntity item) => MaterialPageRoute<bool>(
      builder: (context) => AccountTopUpPage(
            beneficiary: item,
          ));

  final BeneficiaryEntity beneficiary;

  const AccountTopUpPage({super.key, required this.beneficiary});

  @override
  State<AccountTopUpPage> createState() => _AccountTopUpPageState();
}

class _AccountTopUpPageState extends State<AccountTopUpPage> {
  final amountList = [5, 10, 20, 30, 50, 75, 100];
  num amount = 0.0;

  final keyPadUtil = KeyPadUtil();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AuthGuard(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Topup',
          backgroundColor: AppPallete.purple,
        ),
        body: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            if (state is TransactionLoading) {
              printInfo("Loading");
            }
            if (state is TopUpTransactionSuccess) {
              printInfo("Success ${state.transaction.id}");
              Navigator.pushReplacement(
                  context, TransactionDetailPage.route(state.transaction));
            }
            if (state is TransactionFailure) {
              showToast(state.message);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  header(screenSize),
                  const SizedBox(
                    height: 30,
                  ),
                  KeypadWidget(
                    onValueChange: (value) {
                      setState(() {
                        amount = keyPadUtil.onNumberPressed(value);
                      });
                    },
                    onDelete: () {
                      setState(() {
                        amount = keyPadUtil.onDeletePressed();
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: GenericButton(
            color: AppPallete.purple,
            buttonText: "Top Up ${amount.formatAmount("AED ")}",
            onPressed: () {
              if (amount > 0) {
                topUpAmount();
              }
            },
          ),
        ),
      ),
    );
  }

  Container header(Size screenSize) {
    return Container(
      height: screenSize.height * .25,
      width: screenSize.width,
      color: AppPallete.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter topup amount",
            style: TextStyle(color: AppPallete.white, fontSize: 14),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            amount.formatAmount("AED "),
            style: const TextStyle(
                color: AppPallete.white,
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: amountList
                  .map((amount) => amountChip(amount.toString()))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget amountChip(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          amount = keyPadUtil.setValue(value);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white24,
        ),
        child: Center(
          child: Text(
            "AED $value",
            style: const TextStyle(
                color: AppPallete.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void updateAmount(num value) {
    setState(() {
      amount = value;
    });
  }

  topUpAmount() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: "Confirmation",
          message:
              "Please confirm amount topup amount : ${amount.formatAmount('AED ')}",
          icon: FontAwesomeIcons.exclamation,
          onConfirm: () {
            context.read<TransactionCubit>().topUpBenefciary(TopUpParams(
                beneficiaryId: widget.beneficiary.id, amount: amount));
            setState(() {
              amount = 0;
            });
          },
        );
      },
    );
  }
}