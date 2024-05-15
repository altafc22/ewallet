import 'package:flutter/material.dart';

import '../../theme/pallete.dart';

class GenericButton2 extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool filled;
  final Color buttonColor, textColor;
  final double radius;
  const GenericButton2(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.filled = false,
      this.buttonColor = AppPallete.primary,
      this.textColor = AppPallete.white,
      this.radius = 7.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !filled
            ? Border.all(
                color: buttonColor,
                width: .5,
              )
            : null,
        color: filled ? buttonColor : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: _button(text: buttonText, onTap: onPressed, filled: filled),
    );
  }

  Widget _button({
    required text,
    required void Function() onTap,
    required filled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.shade200.withAlpha(100),
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: !filled
                ? Border.all(
                    color: buttonColor,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside)
                : null,
            //color: filled ? buttonColor : null,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(
            child: Text(
              text.toUpperCase(),
              style: TextStyle(color: filled ? textColor : buttonColor),
            ),
          ),
        ),
      ),
    );
  }
}
