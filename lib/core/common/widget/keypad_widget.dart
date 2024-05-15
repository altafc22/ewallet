import 'package:flutter/material.dart';
import 'package:intrinsic_grid_view/intrinsic_grid_view.dart';

import '../../theme/pallete.dart';

class KeyPadController {
  void Function(num value)? updateValue;
}

class KeypadWidget extends StatefulWidget {
  final int decimalPoints;
  final int maxValue;
  final BoxDecoration? decoration;
  final EdgeInsets? keyPadPadding;
  final TextStyle? textStyle;
  final Function(String value) onValueChange;
  final Function onDelete;

  const KeypadWidget({
    super.key,
    this.decimalPoints = 0,
    this.maxValue = 10000,
    this.decoration,
    this.keyPadPadding,
    this.textStyle,
    required this.onValueChange,
    required this.onDelete,
  });

  @override
  State<KeypadWidget> createState() => _KeypadWidgetState();

  void setKeyPadValue(num value) {}
}

class _KeypadWidgetState extends State<KeypadWidget> {
  final keypad = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "del"];

  final defaultDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.white24,
      border: Border.all(width: 2, color: const Color(0xFFD7D7D7)));

  final defaultTextStyle = const TextStyle(
      color: AppPallete.black, fontSize: 24, fontWeight: FontWeight.bold);

  final defaultContainerPadding = const EdgeInsets.all(40);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return IntrinsicGridView.vertical(
          //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          columnCount: 3,
          verticalSpace: 10,
          horizontalSpace: 10,
          children: [
            for (int index = 0; index < keypad.length; index++)
              getKeyItem(index),
          ]);
      // IntrinsicGridView.vertical
      // child: GridView.builder(
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 3,
      //     crossAxisSpacing: 16,
      //     mainAxisSpacing: 16,
      //   ),
      //   itemCount: keypad.length,
      //   itemBuilder: (context, index) {
      //     return getKeyItem(index);
      //   },
      // ),);
    });
  }

  Widget getKeyItem(index) {
    if (keypad[index] == "." && widget.decimalPoints == 0) {
      return Container();
    }
    if (keypad[index] == "del") {
      return _clickableButton(
          child: Icon(
            Icons.backspace,
            color: widget.textStyle != null
                ? widget.textStyle?.color ?? Colors.black
                : Colors.black,
          ),
          onTap: () {
            widget.onDelete();
          });
    }
    return _clickableButton(
        child: Text(
          keypad[index],
          style: widget.textStyle ?? defaultTextStyle,
        ),
        onTap: () {
          widget.onValueChange(keypad[index].toString());
        });
  }

  Widget _clickableButton({required Widget child, required Function() onTap}) {
    return Ink(
      decoration: widget.decoration != null
          ? widget.decoration?.copyWith(
              borderRadius: widget.decoration!.borderRadius,
              color: AppPallete.grey4)
          : defaultDecoration,
      child: SizedBox(
        height: 80,
        width: 80,
        child: InkWell(
          borderRadius: widget.decoration != null
              ? widget.decoration?.borderRadius?.resolve(TextDirection.ltr)
              : BorderRadius.circular(30),
          onTap: () {
            onTap();
          },
          child: Center(child: child),
        ),
      ),
    );
  }
}

class KeyPadUtil {
  String _enteredValue = '';

  num setValue(String value) {
    _enteredValue = value;
    return _enteredValue.isNotEmpty ? double.parse(_enteredValue) : 0;
  }

  num onNumberPressed(String value) {
    _numberPressed(value);
    return _enteredValue.isNotEmpty ? double.parse(_enteredValue) : 0;
  }

  num onDeletePressed() {
    var stringValue = _enteredValue.toString();
    if (stringValue.isNotEmpty) {
      var latestVal = stringValue.substring(0, stringValue.length - 1);
      _updateValue(latestVal);
    }
    return _enteredValue.isNotEmpty ? double.parse(_enteredValue) : 0;
  }

  void _numberPressed(String value) {
    var latestVal = _enteredValue.toString();

    var currentValue = latestVal;

    if (currentValue.isEmpty) {
      currentValue += value;
    } else {
      if (value == '.') {
        var decimalPartLength = currentValue.split('.').length > 1
            ? currentValue.split('.')[1].length
            : 0;
        if (decimalPartLength < 0) {
          currentValue += value;
        }
      } else if (currentValue.contains('.') &&
          currentValue.split('.')[1].length >= 0) {
        return;
      } else if (value == '0' && currentValue == '0') {
        return;
      } else if (value == '0' && isZeroValue() && !currentValue.contains('.')) {
        return;
      } else {
        currentValue += value;
      }
    }
    _updateValue(currentValue);
  }

  String _updateValue(String value) {
    var number = value.isEmpty ? 0 : double.parse(value);

    if (number <= 10000) {
      _enteredValue = value;
    }
    return _enteredValue;
  }

  bool isZeroValue() {
    return _enteredValue.isNotEmpty ? double.parse(_enteredValue) == 0 : true;
  }
}
