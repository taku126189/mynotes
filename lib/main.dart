import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes4/firebase_options.dart';
import 'package:mynotes4/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home:
        const HomePage(), // By changing here, you can see both LoginView and RegistrationView.
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        // FutureBuilder gives you a callback if a future fails.
        // In the callback, FutureBuilder asks you what widget you want to produce for an user depending of the future's result.
        // Firebase.InitializeApp is a future that FutureBuilder performs.
        // If the same user is registered, error occurs. ([ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: [firebase_auth/email-already-in-use] The email address is already in use by another account.)
        builder: (context, snapshot) {
          // asyncsnapshot of an object is the state of that object right now. So that object itself is the result of your future. in this case, it's firebaseapp.
          // we don't need firebase app in snapshot; however, one thing you need in this snapshot is its state.
          // a future has a start point, has a line where it processes its information, and has an end point. It either ends successfully or fails.
          // snapshot is your way of getting the results of your future, whether it has started, it is processing, it is done, or it failed.
          // So, you need to tell an user it is loading and the laoding has finished as soon as the snapshot has finished.
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // if a future is done, this is execute.
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                // this means if the left hand side (user?.emailVerified) is not true, take the right hand side (false).
                print('You are a verified user');
              } else {
                print('You need to verify your emial first');
              }
              // checks if the current user is logged in.
              // anonymous users are those who have not come to the website yet.
              // user.emailVerified causes an error because user is a optional user, which means that .currentUser property is a optional user.
              // you can move your mouse over user to see User? that means if firebase cannot calcuate the current user, it returns null. So the user may be null.
              return const Text('Done');
            // once the ConnectionState is done (i.e., the initialisation of the firebase app is done), done will be printed out.
            default: // a default is a case that says everything else it hasn't handled.
              return const Text('Loading...');
            // If the user's connection is slow, this will be displayed.
          }
        },
      ),
      // onPressed is required. onPressed tells Flutter what to do after the button is pressed.)
    );
  }
}
