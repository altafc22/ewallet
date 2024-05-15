import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content,
    {Color snackBarBg = AppPallete.lightBackground,
    Color cotentBgColor = AppPallete.darkBackground,
    Color contentColor = AppPallete.white}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      //content: Center(child: Text(content)),
      backgroundColor: snackBarBg,
      content: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cotentBgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
            child: Text(
          content,
          style: TextStyle(color: contentColor),
        )),
      ),
      duration: const Duration(seconds: 2),
    ));
}
