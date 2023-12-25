// final user = FirebaseAuth.instance.currentUser; is a getter (property) that returns the firebase user.
// we want auth provider to provide us with the current user.
// we have abstracted away the firebase user with our own auth user (AuthUser).
// we need to return the instance of the AuthUser abstract class
import 'package:mynotes4/services/auth/auth_user.dart';

abstract class AuthProvider {
  // you need to add firebase initialise to firebase auth provider.
  Future<void> initialize();

  // optionally returns the currently authenticated user
  AuthUser? get currentUser;

  // allow the user to log in
  // by using optional value, you do not need to handle exceptions caused by error.
  // e.g., FirebaseAuth.instance.signInWithEmailAndPassword() returns UserCredentials.
  // So, in case the user put incorrect info, you need to handle exceptions. But, if you use optional value like this case, you do not need to do so.
  Future<AuthUser?> logIn({
    // this future returns AuthUser.
    // every user has email and password, so required parameters are used.
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  // logout does not return any value.
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
