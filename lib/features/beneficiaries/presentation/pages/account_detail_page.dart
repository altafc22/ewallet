import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/common/widget/auth_guard.dart';
import 'package:ewallet/core/common/widget/confirmation_dialog.dart';
import 'package:ewallet/core/common/widget/generic_appbar.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/presentation/pages/account_topup_page.dart';
import 'package:ewallet/features/beneficiaries/presentation/widgets/beneficiary_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/app_dimens.dart';
import '../../../../core/common/cubits/transaction/transaction_cubit.dart';
import '../../../../core/common/utils/show_toast.dart';
import '../../../../core/common/widget/profile_field.dart';
import '../bloc/beneficiary_bloc.dart';

class AccountDetailPage extends StatefulWidget {
  static route(BeneficiaryEntity item) => MaterialPageRoute(
      builder: (context) => AccountDetailPage(
            item: item,
          ));

  final BeneficiaryEntity item;

  const AccountDetailPage({super.key, required this.item});

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  late BeneficiaryEntity beneficiary;
  @override
  void initState() {
    super.initState();
    beneficiary = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Account Details',
        backgroundColor: AppPallete.primary,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    title: "Confirmation",
                    message:
                        "Do you really want to remove ${beneficiary.nickname}?",
                    icon: FontAwesomeIcons.exclamation,
                    onConfirm: () {
                      context.read<BeneficiaryBloc>().add(
                            OnDeleteBeneficiary(id: beneficiary.id),
                          );
                      context
                          .read<TransactionCubit>()
                          .getBeneficiaryTransactions(beneficiary.id);
                    },
                  );
                },
              );
            },
            icon: const Icon(
              FontAwesomeIcons.solidTrashCan,
              size: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<BeneficiaryBloc, BeneficiaryState>(
          listener: (context, state) {
            if (state is BeneficiaryFailure) {
              showToast(state.message);
            } else if (state is GetBeneficiarySuccess) {
              setState(() {
                printInfo("New Amount ${state.beneficiary.balance}");
                beneficiary = state.beneficiary;
                printInfo("Amount in beneficiary ${beneficiary.balance}");
              });
            } else if (state is BeneficiarySuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  balance(context, beneficiary.balance),
                  const SizedBox(
                    height: 8,
                  ),
                  field(FontAwesomeIcons.solidUser, "Nick name",
                      beneficiary.nickname),
                  field(FontAwesomeIcons.phone, "Phone number",
                      beneficiary.phoneNumber),
                  field(
                    FontAwesomeIcons.calendarDays,
                    "Created at",
                    beneficiary.createdAt?.formatDate() ?? "",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppPallete.grey4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: BeneficiaryTransactionsWidget(
                                beneficiaryId: beneficiary.id,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  Widget balance(BuildContext context, num balance) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          border: Border.all(width: 1, color: AppPallete.grey3)),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.cardRadius),
                  color: AppPallete.accent),
              child:
                  const Icon(FontAwesomeIcons.simCard, color: AppPallete.white),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Balance",
                  style: TextStyle(
                    color: AppPallete.grey1,
                    fontSize: 14,
                  ),
                ),
                Text(
                  balance.formatAmount("AED "),
                  style: const TextStyle(
                      color: AppPallete.accent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, AccountTopUpPage.route(beneficiary))
                    .then((balance) {
                  context
                      .read<TransactionCubit>()
                      .getBeneficiaryTransactions(beneficiary.id);
                  context
                      .read<BeneficiaryBloc>()
                      .add(OnGetBeneficiary(id: beneficiary.id));
                });
              },
              child: CircleAvatar(
                backgroundColor: AppPallete.accent.withAlpha(50),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: AppPallete.accent,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
