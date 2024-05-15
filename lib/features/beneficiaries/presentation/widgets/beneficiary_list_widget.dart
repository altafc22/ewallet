import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/loader.dart';
import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import 'package:ewallet/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:ewallet/features/beneficiaries/presentation/pages/account_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_list_tile.dart';

class BeneficiaryListWidget extends StatefulWidget {
  const BeneficiaryListWidget({super.key});

  @override
  State<BeneficiaryListWidget> createState() => _BeneficiaryWidgetState();
}

class _BeneficiaryWidgetState extends State<BeneficiaryListWidget> {
  List<BeneficiaryEntity> items = [];

  @override
  void initState() {
    super.initState();
    _fetchAllBenefitiaries();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<BeneficiaryBloc, BeneficiaryState>(
          listener: (context, state) {
     

        if (state is BeneficiaryFailure) {
          showToast(state.message);
        }
        if (state is BeneficiarySuccess) {
          _fetchAllBenefitiaries();
        }
        if (state is BeneficiariesSuccess) {
          setState(() {
            items = state.items;
          });
        }
      }, builder: (context, state) {
        if (state is BeneficiaryLoading) {
          return const Loader();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: _getListItems(),
              ),
            ),
          ],
        );
      }),
    );
  }

  List<Widget> _getListItems() {
    return items.asMap().entries.map((entry) {
      //final index = entry.key;
      final item = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CustomListTile(
          title: item.nickname,
          subtitle: item.phoneNumber,
          onTap: () {
            Navigator.push(context, AccountDetailPage.route(item))
                .then((value) {
              _fetchAllBenefitiaries();
            });
          },
        ),
      );
    }).toList();
  }

  _fetchAllBenefitiaries() {
    context.read<BeneficiaryBloc>().add(OnGetAllBeneficiaries());
  }
}
