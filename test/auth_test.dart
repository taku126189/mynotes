// if you bring a new dependency, you need to recompile (hot restart and hot reload are not enough)
// dev dependencies are not packed inside the application when the application is shipped to the app store.
// usually you need to make a test and then code.

import 'package:mynotes4/services/auth/auth_exceptions.dart';
import 'package:mynotes4/services/auth/auth_provider.dart';
import 'package:mynotes4/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  // test groups can group similar tests together (e.g., test for currentUser, test for initialize, and test for logIn are grouped together)
  group('Mock Authentication', () {
    // create an instance of MockAuthProvider
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

// provider should throw NotInitializedException
// we're testing if (!isInitialized) throw NotInitializedException(); in logOut. if the user is not initialized, it cannot log out.
// upon calling logOut function, we expect the exception.
// throwsA is a matcher
// we're testing the result of the logOut function against a matcher.

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

// execute the function asynch ronously
    test('Should be able to be intialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    // we call the test that executes the initialize function and returs the result before the timeout.
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
// we are calling badEmailUser and upon the creation of badEmailUser, we throw UserNotFoundAuthException
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
// the mock auth provider is not testing whether email and password are correct although firebase does that
// so we provide email and password below. the email and password  should be different from foo@bar.com' and foobar'
      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
// test whether provider.currentUser is actually user.
// we create user above and delegate it to logIn (return logIn(email: email, password: password,);)
// and then, in the logIn function, we set the current user (_user) to the user we just created (user) (_user = user)
      expect(provider.currentUser, user);

      // isEmailVerified parameter of AuthUser is set to false by default
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      // isNotNull is a matcher
      expect(user, isNotNull);
// user is optional so you need to put user!
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

// create MockAuthProvider that mocks AuthProvider
class MockAuthProvider implements AuthProvider {
  AuthUser?
      _user; // you don't have to write AuthUser? user = null; because the optional parameter is null by default.
  var _isInitialized =
      false; // use _ to make this property private to the mock authprovider.
  // when we are testing our mock auth provider, we say are you initialized?
  // when we create mock auth provider, we should not initially initialized.
  // however, after calling initialized on it, then we make a test to make sure intialized flag is set to true.
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    // if the mock auth provider is not initialized, throw NotInitializedException();
    // fake creating a user. usually if you call createuser on firebase, it takes time since it is talking with firebase. so you need to create delay (fake making API call)
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    ); // calls the logIn function if email and password are the same.
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException;
    // sendEmailVerification makes sure if the user is already logged in.
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser; // current user (_user) is newUser
  }
}
