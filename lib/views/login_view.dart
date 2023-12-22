import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:mynotes4/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes4/constants/routes.dart';
// why print function isn't a good idea?
// Writing to the console can slow down the app, especially if the logs are being written frequently. This can result in a noticeable decrease in app performance. In a production environment, it may be difficult to replicate the conditions that caused an issue, making it harder to debug the problem. Also, print statements can sometimes make the debugging process more difficult, as they can interfere with the normal operation of the app.

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
            keyboardType:
                TextInputType.emailAddress, // to make @ appear in a keyboard

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

            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              // After making TextField widgets for email and password, you need to pass the information an user inputs to TextButton widget. To do so, you need to create a text editing controller. In other words, a text editing controller is a proxy object that links between TextField and TextButton.

              final email = _email.text;
              final password = _password.text;
              // exceptions are something that developers have not accounted for when they created a system.
              // try catch block is useful in this case.
              // the try block does the work that you are saying it needs to be done.
              // should anything bad happened, it will go to catch statements that follow.
              try {
                // final userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // devtools.log(userCredential.toString()); // .toString is a function of userCredential.
                Navigator.of(context).pushNamedAndRemoveUntil(
                  noteRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log('User not found');
                } else if (e.code == 'wrong-password') {
                  devtools.log('Wrong password');
                }
              } // user registration is an asyncronous task which means that it is not going to be done immediately.
              // createUserWithEmailAndPassword is Future. So, it will calculate in the future, not now.
            },
            child: const Text('Login'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
    // return Scaffold(
    // appBar: AppBar(
    // title: const Text('Login'),
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
