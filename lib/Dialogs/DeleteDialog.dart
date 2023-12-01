import 'package:flutter/material.dart';
import 'package:train/Dialogs/Generic_dialog.dart';

Future<bool> deleteDialog(
  BuildContext context,
) {
  return GenericDialog(
    context: context,
    title: 'Delete',
    text: 'Are you sure you want to delete this note ?',
    optionstoselect: () => {'OK': true, 'Cancel': false},
  ).then((value) => value ?? false);
}
