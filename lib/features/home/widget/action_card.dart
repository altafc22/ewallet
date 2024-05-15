import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Function() onPressed;
  const ActionCard(
      {super.key,
      required this.label,
      required this.icon,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(100),
              radius: 30,
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
