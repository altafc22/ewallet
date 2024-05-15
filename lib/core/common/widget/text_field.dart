import 'package:ewallet/core/app_dimens.dart';
import 'package:ewallet/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class MyTextField extends StatefulWidget {
  final IconData? icon;
  final String? labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool passwordField;
  final int maxLength;
  final TextInputType inputType;
  final Function()? onTap;
  final bool readOnly;
  final bool disabled;
  final TextAlign textAlign;
  final Function(String? value)? onValidate;
  final Function? onChanged;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final Widget? iconWidget;
  final String? error;
  final AutovalidateMode? autoValidation;
  final String? Function(String? value)? validator;

  MyTextField(
      {Key? key,
      this.icon,
      this.labelText,
      required this.hintText,
      this.controller,
      this.passwordField = false,
      this.maxLength = 30,
      this.inputType = TextInputType.text,
      this.textAlign = TextAlign.start,
      this.onValidate,
      this.onTap,
      this.readOnly = false,
      this.disabled = false,
      this.contentPadding,
      this.onChanged,
      this.fillColor,
      this.iconWidget,
      this.error,
      this.autoValidation,
      this.validator})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool obscureText;

  final FocusNode _nodeText1 = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.passwordField;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !widget.disabled,
      cursorColor: Colors.black,
      focusNode: _nodeText1,
      controller: widget.controller,
      obscureText: obscureText,
      maxLength: widget.maxLength,
      keyboardType: widget.inputType,
      autovalidateMode: widget.autoValidation, //widget.autoValidation,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator ??
          (value) {
            if (widget.onValidate != null) {
              //return widget.onValidate!(value);
              if (value!.isEmpty) {
                return "${widget.hintText} is required";
              }
              return null;
            }
            return null;
          },
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        letterSpacing: 0.15,
      ),
      textAlign: widget.textAlign,
      onChanged: (value) =>
          widget.onChanged != null ? widget.onChanged!(value) : null,
      decoration: InputDecoration(
        counterText: "",
        errorText: widget.error,
        errorStyle: const TextStyle(height: 0, color: AppPallete.red),
        fillColor: widget.disabled ? AppPallete.grey2 : widget.fillColor,
        filled: (widget.fillColor != null || widget.disabled) ? true : false,
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            letterSpacing: 0.15),
        labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15),
        prefixIcon: widget.icon != null
            ? Transform.flip(
                flipX: false,
                child: Icon(
                  widget.icon,
                  color: Colors.black,
                  size: 18,
                ),
              )
            : widget.iconWidget,
        suffixIcon: widget.passwordField
            ? IconButton(
                icon: obscureText
                    ? const Icon(Iconsax.eye, color: Colors.black, size: 18)
                    : const Icon(
                        Iconsax.eye_slash,
                        color: Colors.black,
                        size: 18,
                      ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(AppDimens.textFieldRadius),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(AppDimens.textFieldRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPallete.red, width: 2),
          borderRadius: BorderRadius.circular(AppDimens.textFieldRadius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPallete.red, width: 2),
          borderRadius: BorderRadius.circular(AppDimens.textFieldRadius),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.textFieldRadius),
        ),
      ),
    );
  }

  bool isObscureText() => widget.passwordField ? true : false;
}
