import 'package:ewallet/core/app_dimens.dart';
import 'package:ewallet/core/common/utils/show_toast.dart';
import 'package:ewallet/core/common/widget/text_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_style.dart';
import '../../../../core/common/widget/generic_button2.dart';

class AddBeneficiaryDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  AddBeneficiaryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        padding: const EdgeInsets.all(AppDimens.scaffoldPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Account",
                  style: headLine3,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              controller: nameController,
              hintText: "Account nick name",
              inputType: TextInputType.name,
              maxLength: 20,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Account name is required';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              controller: phoneController,
              hintText: "Phone number",
              inputType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Account number is required';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GenericButton2(
                    buttonText: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GenericButton2(
                    buttonText: 'Submit',
                    filled: true,
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty) {
                        showToast('Please fill in all required fields');
                      } else {
                        // Close the dialog and pass the input data
                        Navigator.of(context).pop({
                          'name': nameController.text,
                          'phone': phoneController.text,
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
