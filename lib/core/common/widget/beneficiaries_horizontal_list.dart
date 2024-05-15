import 'package:ewallet/core/common/widget/loader.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/beneficiaries/domain/entitiy/beneficiary_entity.dart';
import '../../../features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import '../../../features/beneficiaries/presentation/pages/account_detail_page.dart';
import '../../../features/beneficiaries/presentation/widgets/beneficiary_list_widget.dart';
import '../utils/show_toast.dart';

class BeneficiaryHorizontalListWidget extends StatefulWidget {
  const BeneficiaryHorizontalListWidget({super.key});

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
              scrollDirection: Axis.horizontal,
              children: _getListItems(),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _getListItems() {
    return items.asMap().entries.map((entry) {
      //final index = entry.key;
      final item = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, AccountDetailPage.route(item))
                .then((value) {
              _fetchAllBenefitiaries();
            });
          },
          child: Container(
              height: 100,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppPallete.accent),
              child: Column(
                children: [
                  Text(item.nickname),
                  Text(
                    item.phoneNumber,
                  )
                ],
              )),
        ),
      );
    }).toList();
  }

  _fetchAllBenefitiaries() {
    context.read<BeneficiaryBloc>().add(OnGetAllBeneficiaries());
  }
}
