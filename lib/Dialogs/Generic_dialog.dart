import 'package:flutter/material.dart';

typedef OptionSelect<T> = Map<String, T?> Function();

Future<T?> GenericDialog<T>({
  required BuildContext context,
  required String title,
  required String text,
  required OptionSelect optionstoselect,
}) async {
  final options = optionstoselect();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: options.keys.map((optionstitle) {
          final value = options[optionstitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionstitle),
          );
        }).toList(),
      );
    },
  );
}
