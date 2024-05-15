import 'package:ewallet/core/app_dimens.dart';
import 'package:flutter/material.dart';

import '../../theme/pallete.dart';

class GenericButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;
  const GenericButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.color = AppPallete.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, AppDimens.buttonHeight),
            backgroundColor: color,
            shadowColor: AppPallete.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
        child: Text(
          buttonText.toUpperCase(),
          style: const TextStyle(color: AppPallete.white),
        ),
      ),
    );
  }
}
