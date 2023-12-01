import 'package:flutter/material.dart';
import 'package:train/Dialogs/Generic_dialog.dart';

Future<void> showErrordialog(
  BuildContext context,
  String text,
) {
  return GenericDialog(
    context: context,
    title: 'An error occured',
    text: text,
    optionstoselect: () => {'Ok': null},
  ).then((value) => value ?? false);
}
