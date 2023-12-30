// Generic dialog is a generic function taht can provide the value nased on what you provide to it
// yes or no, each contains a boolean value
// all buttons in a generic dialog are going to have the same data type value
// Future<T?> showGenericDialog<T>() {} is a function signature
// T? is for the user dismissing the dialog without responding it. in iOS, if the user press an area outside of the dialoge, they can dismiss it.
import 'package:flutter/material.dart';

// every button should have text and optional value so we are going to use Map
// we dont want to manage list of titles and list of values separately, so map is used.
// every buttons has a title. every title is insde the map of string
// every string is unique because of T. you cannot have two buttons with the same title
// in Map, every key must be unique in key-value pairs. values are the data and unique keys are identifiers
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder(); // call the function
  return showDialog<T>(
    // two parameters we want to pass, context and builder
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
// actions are defined in options. Every key inside this options is the tile which is defined by string off actions of our dialog
// actions require List of widgets so you need to add toList()
// map function is used for transforming a list of data into a list of widget. E.g., mapping a list of strings to a list of 'Text' widgets
        actions: options.keys.map((optionTitle) {
          // get the values of this keys
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              // value is optional because of Map<String, T?> Function();
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
