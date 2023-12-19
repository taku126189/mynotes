// Registration view
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:mynotes4/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // late means that although i cannot provide value for now, I promise I will give it value before the programme is run.
  // initState is a function that will be automatically called by Flutter when it makes a homepage.
  // when the homepage goes out of memory, it will get a function called dispose.

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          // Column widget has a children property that is made up of a list.
          TextField(
            controller:
                _email, // you hooked the TextEditing Controller in TextField.
            enableSuggestions:
                false, // you do not want suggestiosn to appear when an user is typing their password.
            autocorrect:
                false, // you don not want autocorrect to work when an user is typing their password.

            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true, // it makes password invisible.
            enableSuggestions:
                false, // you do not want suggestiosn to appear when an user is typing their password.
            autocorrect:
                false, // you don not want autocorrect to work when an user is typing their password.
            keyboardType:
                TextInputType.emailAddress, // to make @ appear in a keyboard
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              // After making TextField widgets for email and password, you need to pass the information an user inputs to TextButton widget. To do so, you need to create a text editing controller. In other words, a text editing controller is a proxy object that links between TextField and TextButton.
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        // the user is registered in this link: https://console.firebase.google.com/u/0/project/mynotes4-flutter-takuyasaka/authentication/users
                        email: email,
                        password: password);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print(
                      'Weak password'); // if the error code is weak-password, Weak password is printed out in debug console.
                } else if (e.code == 'email-already-in-use') {
                  // // if the error code is email-already-in-use, Email is already in use is printed out in debug console.
                  print('Email is already in use');
                } else if (e.code == 'invalid-email') {
                  print('Invalid email');
                }
              }

              // you need to handle weak password. print(e.code) allows you to see weak password error in debug console.
            }, // user registration is an asyncronous task which means that it is not going to be done immediately.
            // createUserWithEmailAndPassword is Future. So, it will calculate in the future, not now.
            child: const Text('You wanna register?'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );

    // return Scaffold(
    // appBar: AppBar(
    // title: const Text('Register'),
    // ),
    // body: FutureBuilder(
    // future: Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform),
    // FutureBuilder gives you a callback if a future fails.
    // In the callback, FutureBuilder asks you what widget you want to produce for an user depending of the future's result.
    // Firebase.InitializeApp is a future that FutureBuilder performs.
    // If the same user is registered, error occurs. ([ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: [firebase_auth/email-already-in-use] The email address is already in use by another account.)
    // builder: (context, snapshot) {
    // asyncsnapshot of an object is the state of that object right now. So that object itself is the result of your future. in this case, it's firebaseapp.
    // we don't need firebase app in snapshot; however, one thing you need in this snapshot is its state.
    // a future has a start point, has a line where it processes its information, and has an end point. It either ends successfully or fails.
    // snapshot is your way of getting the results of your future, whether it has started, it is processing, it is done, or it failed.
    // So, you need to tell an user it is loading and the laoding has finished as soon as the snapshot has finished.
    // switch (snapshot.connectionState) {
    // case ConnectionState.done:
    // if a future is done, this is executed

    // default: // a default is a case that says everything else it hasn't handled.
    // return const Text('Loading...');
    // If the user's connection is slow, this will be displayed.
    // }
    // },
    // ),
    // onPressed is required. onPressed tells Flutter what to do after the button is pressed.)
    // );
  }
}
