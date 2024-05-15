import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/pallete.dart';

class BalanceViewer extends StatefulWidget {
  final String balance;
  BalanceViewer({super.key, required this.balance});

  @override
  State<BalanceViewer> createState() => _BalanceViewerState();
}

class _BalanceViewerState extends State<BalanceViewer> {
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isHidden = !isHidden;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Wallet Balance: ",
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                color: AppPallete.white,
              )),
          Text(isHidden ? '•' * widget.balance.length : widget.balance,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppPallete.white)),
          const SizedBox(
            width: 5,
          ),
          const FaIcon(
            FontAwesomeIcons.solidEye,
            size: 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
