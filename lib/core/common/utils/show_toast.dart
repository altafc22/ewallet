import 'package:ewallet/core/theme/pallete.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppPallete.darkBackground,
      textColor: AppPallete.white,
      fontSize: 14.0);
}
