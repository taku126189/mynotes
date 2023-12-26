import 'package:mynotes4/services/auth/auth_provider.dart';
import 'package:mynotes4/services/auth/auth_user.dart';
import 'package:mynotes4/services/auth/firebase_auth_provider.dart';

// AuthService relays the messages of the given auth provider, but can have more logic.

class AuthService implements AuthProvider {
  final AuthProvider provider;
// dependency injection.
// AuthService is dependent on AuthProvider. it is not just making an assumption that AuthProvider is firebase, it provides a facotry firebase. But it is not making the assumption that it is always locked to firebase authprovider
// constructor (initializer) injects provider into it.
  const AuthService(this.provider);

// add firebase factory to firebase authservice.
// return the instnce of authservice that is already configured with a firebase auth provider
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
