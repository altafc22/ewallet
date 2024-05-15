import 'package:ewallet/core/app_asset.dart';
import 'package:ewallet/core/app_dimens.dart';
import 'package:ewallet/core/app_extension.dart';
import 'package:ewallet/core/app_string.dart';
import 'package:ewallet/core/common/widget/generic_appbar.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';

import '../../../../core/common/entities/transaction/transasction_entity.dart';

class TransactionDetailPage extends StatelessWidget {
  static route(TransactionEntity item) => MaterialPageRoute<bool>(
      builder: (context) => TransactionDetailPage(
            transaction: item,
          ));

  final TransactionEntity transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: AppPallete.primary,
        title: 'Transaction Details',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.scaffoldPadding),
          child: Center(
            child: SingleChildScrollView(
              child: SKSTicketView(
                backgroundPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                backgroundColor: AppPallete.grey3,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                borderRadius: 6,
                drawDivider: false,
                drawArc: false,
                triangleSize: const Size(0, 0),
                trianglePos: 0.5,
                triangleAxis: Axis.vertical,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppPallete.primary,
                            maxRadius: 24,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                AppAsset.appIcon,
                                color: AppPallete.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            AppString.appName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppPallete.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        transaction.transactionCategory!.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildDetailItem(
                          'Transaction ID', transaction.id!.toUpperCase()),
                      _buildDetailItem(
                          'Date', transaction.createdAt!.formatDate()),
                      // _buildDetailItem(
                      //   'Description',
                      //   transaction.description ?? 'NA',
                      // ),
                      transaction.beneficiaryId != null
                          ? _buildDetailItem(
                              'Account (Sim)',
                              transaction.beneficiaryId!.nickname ?? "",
                            )
                          : Container(),
                      transaction.beneficiaryId != null
                          ? _buildDetailItem(
                              'Phone Number',
                              transaction.beneficiaryId!.phoneNumber ?? "",
                            )
                          : Container(),
                      _buildDetailItem(
                        'Category',
                        transaction.transactionCategory ?? "",
                      ),
                      _buildDetailItem(
                        'Created By',
                        transaction.userId!.name ?? "",
                      ),
                      _buildDetailItem(
                        'Status',
                        transaction.transactionStatus ?? "",
                      ),
                      _buildDetailItem(
                        'Amount',
                        transaction.transactionAmount!.formatAmount("AED "),
                      ),
                      _buildDetailItem(
                        'Fee',
                        transaction.transactionFee!.formatAmount("AED "),
                      ),
                      _buildDetailItem(
                        'Total Amount',
                        transaction.totalAmount!.formatAmount("AED "),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      QrImageView(
                        data: transaction.id ?? "",
                        version: QrVersions.auto,
                        size: 150.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
