// You should not expose firebase's user to the UI.
// by using show, it enables not expsoing too many packages except for the user class. You can prefix user by adding as FirebaseAuth before show User. (i.e., FirebaseAuth.User)
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable // annotation that says any subclasses of this class are going to be immutable
// their internals are never going to be changed upon initialisation.
// that is, if you code 'class MyAuthUser extends Auth User {const MyAuthUser(bool isEmailVerified) : super(isEmailVerified);}', you have to put const because it should be immutable.
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  // user.isEmailVerified makes more sense than saying user.emailVerified.
  // constructor.
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
  // factory constructer is useful.
  // say if you want to object x from object y. obejct x can initialise itself and construct itself. Without factory constructor, you need to add a middle layer between object x and object y.
  // AuthUser(user.emailVerified) goes into const AuthUser(this.isEmailVerified);
  // it takes the value of emailVerified of the firebase user and places it into the AuthUser class. (like making a copy of the firebase user into AuthUser class so that it avoids directly exposing the firebase user to the ui.)
  // you neet to put  const AuthUser({required this.isEmailVerified}); Otherwise, you need to put AuthUser(true) and it does not make sense to other programmers.
}
