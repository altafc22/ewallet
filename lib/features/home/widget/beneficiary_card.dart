import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/pallete.dart';
import '../../beneficiaries/domain/entitiy/beneficiary_entity.dart';

class BeneficiaryCard extends StatelessWidget {
  final BeneficiaryEntity item;
  final Function(BeneficiaryEntity item) onButtonClick;
  final Function(BeneficiaryEntity item) onCardClick;
  const BeneficiaryCard({
    super.key,
    required this.item,
    required this.onButtonClick,
    required this.onCardClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCardClick(item);
      },
      child: Container(
          height: 100,
          width: 140,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppPallete.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  item.nickname,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Flexible(
                child: Text(
                  item.phoneNumber,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  onButtonClick(item);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: const Center(
                      child: Text(
                    "Topup Now",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          )),
    );
  }
}

class BeneficiaryCardShimmer extends StatelessWidget {
  const BeneficiaryCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.red),
        child: const FadeShimmer(
          height: 100,
          width: 130,
          radius: 8,
          highlightColor: Color(0xffF9F9FB),
          baseColor: Color(0xffE6E8EB),
        ));
  }
}
