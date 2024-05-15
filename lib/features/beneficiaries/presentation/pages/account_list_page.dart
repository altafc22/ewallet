import 'package:ewallet/core/common/widget/auth_guard.dart';
import 'package:ewallet/core/common/widget/generic_appbar.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:ewallet/features/beneficiaries/domain/usecases/add_beneficiary.dart';
import 'package:ewallet/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:ewallet/features/beneficiaries/presentation/widgets/add_beneficiary_dailog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/beneficiary_list_widget.dart';

class AccountPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AccountPage());

  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Accounts",
          backgroundColor: AppPallete.primary,
          actions: [
            IconButton(
              onPressed: () {
                _showCustomDialog(context);
              },
              icon: const Icon(
                FontAwesomeIcons.plus,
                size: 22,
              ),
            )
          ],
        ),
        body: const BeneficiaryListWidget(),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBeneficiaryDialog();
      },
    );

    if (result != null) {
      final name = result['name'];
      final phone = result['phone'];
      var params = BeneficiaryParams(nickname: name, phoneNumber: phone);
      context.read<BeneficiaryBloc>().add(OnAddBeneficiary(params: params));
    }
  }
}
