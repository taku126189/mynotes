import 'package:flutter/material.dart';
import 'package:mynotes4/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
      context: context,
      title: 'An error occurred',
      content: text,
      // optionsBuilder is a Function that returns a map
      optionsBuilder: () => {
            // key
            'OK': null,
          });
}
