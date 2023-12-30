import 'package:flutter/material.dart' show BuildContext, ModalRoute;

// extension adds a new method to an exisiting class
// An extension, GetArgument is defined on the BuildContext class
// It adds a method called getArgument.
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    // if we cannot get the modal route, we cannot extract any argument
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      // if we could grab any arguments from our modal route settings argumnets and if the argument is of the type that you are asking this function to extract, the we are going to give it back, otherwide, we're just going to fall through to return null;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
