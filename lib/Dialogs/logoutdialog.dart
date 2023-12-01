import 'package:flutter/material.dart';
import 'package:train/Dialogs/Generic_dialog.dart';

Future<bool> logoutdialog(BuildContext context) async {
  return GenericDialog<bool>(
    context: context,
    title: 'Logout',
    text: 'Are you sure you want to logout?',
    optionstoselect: () => {
      'Ok': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
