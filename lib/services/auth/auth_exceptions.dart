// auth provider and auth service
// firebase is a low level abstraction layer.
// The UI is high level so now firebase and the ui is talking with each other directly
// there should be some laybers in between that abstract away the firebase functionalities from the ui.
// auth provider is able to provide basic firebase functionalities such as return current user, allow user to log in and log out and send email verification etc.
//  UI - auth service - auth provider - firebase

// login exceptions
class UserNotFoundAuthException
    implements
        Exception {} // Exceptions is already included as default so there is no need to import.

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
