import 'package:flutter/material.dart';
import 'package:mynotes4/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      // keys and values in Map
      'Cancel': false,
      'Logout': true
    },
  ).then(
    (value) => value ?? false,
  );
}
