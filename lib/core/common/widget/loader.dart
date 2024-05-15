import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool showText;
  const Loader({super.key, this.showText = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: showText ? 100 : null,
        width: showText ? 80 : null,
        decoration: BoxDecoration(
          //color: AppPallete.grey3,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppPallete.primary,
            ),
            showText
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox(),
            showText
                ? const Text(
                    "Loading",
                    style: TextStyle(color: Colors.black38),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
