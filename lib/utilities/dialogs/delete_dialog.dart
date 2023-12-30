import 'package:flutter/material.dart';
import 'package:mynotes4/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      // keys and values in Map
      'Cancel': false,
      'Yes': true
    },
  ).then(
    (value) => value ?? false,
  );
}
