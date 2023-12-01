import 'package:flutter/material.dart';
import 'package:train/Dialogs/Generic_dialog.dart';

Future<void> showPasswordForgetDialog(BuildContext context) {
  return GenericDialog(
    context: context,
    title: 'Password Reset',
    text: 'We have sent a password reset link ! check your email',
    optionstoselect: () => {
      'Ok': null,
    },
  );
}
