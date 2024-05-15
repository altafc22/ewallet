import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final double radius;
  final Color background;
  final double elevation;
  final double? height;
  final double? width;
  final Widget? child;

  const RoundedCard(
      {super.key,
      this.child,
      this.width,
      this.height = 100,
      this.radius = 16,
      this.background = Colors.white,
      this.elevation = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 16,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: child,
    );
  }
}
