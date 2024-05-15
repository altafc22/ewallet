import 'package:flutter/material.dart';

import '../../theme/pallete.dart';

Widget field(IconData icon, String title, String subTitle) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0),
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //border: Border.all(width: 1, color: AppPallete.grey3),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          leading: CircleAvatar(
            backgroundColor: AppPallete.accent.withAlpha(50),
            child: Icon(
              icon,
              color: AppPallete.accent,
              size: 18,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppPallete.grey1),
          ),
          subtitle: Text(
            subTitle,
            style: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
