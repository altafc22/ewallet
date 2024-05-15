import 'package:collection/collection.dart';
import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/common/cubits/transaction/transaction_cubit.dart';
import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/generic_appbar.dart';
import 'package:ewallet/core/common/widget/loader.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/features/transaction/presentation/pages/transacation_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/common/entities/transaction/transasction_entity.dart';
import '../../../../core/common/widget/no_items_widget.dart';

class TransactionListPage extends StatefulWidget {
  static route() => MaterialPageRoute<bool>(
      builder: (context) => const TransactionListPage());

  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  List<TransactionEntity> items = [];
  List<TransactionEntity> rechargeItems = [];
  List<TransactionEntity> topupItems = [];

  @override
  void initState() {
    super.initState();
    printInfo("Init Transaction List");
    _controller = TabController(length: 2, vsync: this);
    context.read<TransactionCubit>().getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Transactions",
          backgroundColor: AppPallete.primary,
        ),
        body: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            if (state is TransactionLoading) {
              printInfo("Loading");
            }
            if (state is TransactionFailure) {
              showToast(state.message);
            }
            if (state is GetTransactionSuccess) {
              printInfo("Items: ${items.length}");
              items = state.transactions;
              var groupedTransactions = groupBy(
                  items,
                  (TransactionEntity transaction) =>
                      transaction.transactionCategory);
              rechargeItems = groupedTransactions['Wallet Recharge'] ?? [];
              topupItems = groupedTransactions['TopUp'] ?? [];
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Loader();
            }
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                        color: AppPallete.primary),
                    padding: const EdgeInsets.all(3),
                    child: TabBar(
                      padding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: AppPallete.accent,
                      controller: _controller,
                      splashBorderRadius: BorderRadius.circular(30),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppPallete.white),
                      labelColor: AppPallete.primary,
                      unselectedLabelColor: AppPallete.white,
                      tabs: const [
                        Tab(child: Text('Wallet Recharge')),
                        Tab(child: Text('Simcard Topup')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        topupItems.isEmpty
                            ? NoItemsWidget()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: rechargeItems.length,
                                itemBuilder: (context, index) {
                                  return listItem(rechargeItems[index]);
                                },
                              ),
                        topupItems.isEmpty
                            ? Container()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: topupItems.length,
                                itemBuilder: (context, index) {
                                  return listItem(topupItems[index]);
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
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
            leading: CircleAvatar(
              backgroundColor: AppPallete.white,
              child: Icon(
                item.transactionCategory == "TopUp"
                    ? FontAwesomeIcons.simCard
                    : FontAwesomeIcons.wallet,
                color: AppPallete.accent,
                size: 18,
              ),
            ),
            title: Text(
              item.transactionCategory ?? '',
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
