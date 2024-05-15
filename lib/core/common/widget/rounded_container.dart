import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final double padding;
  final Color? color;
  final double radius;
  final double? height, width;
  const RoundedContainer(
      {super.key,
      this.width,
      this.height,
      this.child,
      this.padding = 10,
      this.color = Colors.red,
      this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
