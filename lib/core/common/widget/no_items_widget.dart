import 'package:ewallet/core/app_asset.dart';
import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  NoItemsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          AppAsset.notItems,
          height: 200,
        ),
      ),
    );
  }
}
