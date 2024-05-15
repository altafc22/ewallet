import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title, subtitle;

  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon = FontAwesomeIcons.simCard,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //border: Border.all(width: 1, color: AppPallete.grey3),
          color: AppPallete.grey4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ListTile(
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
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppPallete.grey1),
          ),
        ),
      ),
    );
  }
}
