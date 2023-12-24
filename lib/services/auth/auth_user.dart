// You should not expose firebase's user to the UI.
// by using show, it enables not expsoing too many packages except for the user class. You can prefix user by adding as FirebaseAuth before show User. (i.e., FirebaseAuth.User)
import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailVerified;

  const AuthUser(
      this.isEmailVerified); // user.isEmailVerified makes more sense than saying user.emailVerified.
}
