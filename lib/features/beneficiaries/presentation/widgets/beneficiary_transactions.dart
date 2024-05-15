import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/cubits/transaction/transaction_cubit.dart';
import 'package:ewallet/core/common/entities/transaction/transasction_entity.dart';
import 'package:ewallet/core/common/widget/loader.dart';
import 'package:ewallet/features/transaction/presentation/pages/transacation_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/pallete.dart';

class BeneficiaryTransactionsWidget extends StatefulWidget {
  final String beneficiaryId;
  const BeneficiaryTransactionsWidget({super.key, required this.beneficiaryId});

  @override
  State<BeneficiaryTransactionsWidget> createState() =>
      _BeneficiaryTransactionsWidgetState();
}

class _BeneficiaryTransactionsWidgetState
    extends State<BeneficiaryTransactionsWidget> {
  List<TransactionEntity> items = [];

  @override
  void initState() {
    super.initState();
    context
        .read<TransactionCubit>()
        .getBeneficiaryTransactions(widget.beneficiaryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is GetTransactionSuccess) {
          items = state.transactions;
        }
      },
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Loader();
        }
        return Material(
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return listItem(items[index]);
            },
          ),
        );
      },
    );
  }

  Widget listItem(TransactionEntity item) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //border: Border.all(width: 1, color: AppPallete.grey3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(context, TransactionDetailPage.route(item));
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            tileColor: AppPallete.grey4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            dense: true,
            leading: const CircleAvatar(
              backgroundColor: AppPallete.white,
              child: Icon(
                FontAwesomeIcons.moneyBill,
                color: AppPallete.accent,
                size: 18,
              ),
            ),
            title: Text(
              item.transactionCategory ?? "",
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item.createdAt!.formatDate(),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.green.withAlpha(100)),
              child: Text(
                "+ ${item.transactionAmount!.formatAmount("AED ")}",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
