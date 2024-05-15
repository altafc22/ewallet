import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static darkTheme(BuildContext context) => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppPallete.darkBackground,
        appBarTheme:
            const AppBarTheme(backgroundColor: AppPallete.darkBackground),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      );
  static lightTheme(BuildContext context) => ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppPallete.lightBackground,
        appBarTheme:
            const AppBarTheme(backgroundColor: AppPallete.lightBackground),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      );
}
