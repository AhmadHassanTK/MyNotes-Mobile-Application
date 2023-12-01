import 'package:flutter/material.dart';
import 'package:train/Dialogs/Generic_dialog.dart';

Future<void> cannotShareNoteDialog(
  BuildContext context,
) {
  return GenericDialog<void>(
    context: context,
    title: 'Sharing',
    text: 'You cannot share an empty note!',
    optionstoselect: () => {
      'Ok': null,
    },
  );
}
