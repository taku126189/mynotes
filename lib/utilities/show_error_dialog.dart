// creates a dialog and displays it
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      // builder expects something to return
      return AlertDialog(
        title: const Text('An error occurred'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // the dialog gets dismissed
            },
            child: const Text('OK'),
          ),
        ],
      );
      // title is a widget, not string
    },
  );
}
