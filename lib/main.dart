// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:mynotes4/constants/routes.dart'; // VS code automatically imports this for const loginRoute.
import 'package:mynotes4/services/auth/auth_service.dart';
import 'package:mynotes4/views/login_view.dart';
import 'package:mynotes4/views/notes_view.dart';
import 'package:mynotes4/views/register_view.dart';
import 'package:mynotes4/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log;
// import statements are configureable. There are many functions that you don't need and you can see all functions by pressing ctrl and space.
// Hence, use as and show to limit the package you import and use functions you actually need.

void main() async {
  // the main function is not recompiled even if you did a hot reload. "recompile" refers to the process of rebuilding the application's source code into machine-readable code (such as native machine code or intermediate code) that can be executed on the target platform. This compilation process is necessary whenever changes are made to the source code of a Flutter app. When you make changes to your Flutter project, such as modifying Dart code, adding dependencies, or adjusting configuration files, you need to recompile the application to see the effects of those changes. The Flutter framework provides a hot reload feature, which allows you to see the results of your code changes quickly without restarting the entire application.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          const HomePage(), // By changing here, you can see both LoginView and RegistrationView.
      routes: {
        // named rountes. all routes parameters are registered here.
        loginRoute: (context) =>
            const LoginView(), // this returns the instance of loginview.
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      }, // routes are parameter. it's a map with keys being strings and values being functions. it returns a widget and the function takes buildcontext inside.
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),

      // future: Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform),
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
            final user = AuthService.firebase().currentUser;
            // final user =
            //     FirebaseAuth.instance.currentUser; // get the current user.
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView(); // if the user is not null (i.e., the user is present) and the user is verified, it prints out email is verified.
              } else {
                return const VerifyEmailView(); // if the user is not null and the user is not verified, it returns VerifyEmailView.
              }
            } else {
              return const LoginView(); // if the user is null, it returns LoginView.
            }
          // return const Text('Done'); // Upon the firebase initialisation being done succefully, checks the current user. If the current user is already logged in and verified, it returns done.
          // print(user);
          // if (user?.emailVerified ?? false) {
          //   return const Text('Done');

          //   // this means if the left hand side (user?.emailVerified) is not true, take the right hand side (false).
          // } else {
          //   return const VerifyEmailView();
          //   //  this creates Navigator (class) and tells Navigator to push something on the screen.
          //   // Then we say, create MaterialPageRoute to push.
          //   // MaterialPageRoute has an argument called builder, which expects a widget.
          // }
          // return const LoginView();
          // checks if the current user is logged in.
          // anonymous  users are those who have not come to the website yet.
          // user.emailVerified causes an error because user is a optional user, which means that .currentUser property is a optional user.
          // you can move your mouse over user to see User? that means if firebase cannot calcuate the current user, it returns null. So the user may be null.
          default: // a default is a case that says everything else it hasn't handled.
            return const CircularProgressIndicator();
          // If the user's connection is slow, the loading indicator will be displayed.
        }
      },
    );
    // Builder widget is expected to return some widget. It is like a contract.
    // if the future is done, the text done will be printed out.
    // onPressed is required. onPressed tells Flutter what to do after the button is pressed.)
    // you need to remove scaffold from homepage because loginview has a scafold and is embedded in homepage.
  }
}



// named routes vs anonymous routes
// routes are a journey. it has a start view and end view.
// named routes tell Flutter where to go beforehand.
// anonymous routes does not tell Flutter the final destination.

// Git and GitHub
// you need to use these services to store your code.
// What is Git?
// it is a piece of software on your computer to manage changes you made to the codebase.
// git reporsitory is an empty bucket initially. It is like a project folder that contains all files and dictionaries related to your project. It stores the entire history of changes you made to your project.
// you need to tell Git to save a file you want to save. untracked files are files that you have not told Git about it. (git add info.txt)
// commit means you are going to save it in Git. (git commit -m "add new info.txt file for fun")
// What is GitHub?
// GitHub is a cloud service where git repositories are stored.
// If you save your code in Git, nobody else can see and modify it.
// If you want to share your code with other people and want to collaborate with them and want to be able to commit to it in the sourcecode,
// you can share it in GitHub.
// git log
// git status is to display the status of your working direcotry and staging area with respect to the git repository.
// staging area (a.k.a. index) is a middle ground between your working directory and the git repository. You can choose which changes  you want to include in your next commit.
// Use the git add command to stage specific modifications.
// working directory is where you make modifications to your files. You edit, create, or delete files.
// git init . is to make your local repository a git repository
// git add --all is to add all changes to the statging area.
// git commit -m "XYZ" is to create a new commit with a specified commit message.
// git push is used to upload local changes to a remote repository. Hence, Before using git push, you typically set up a remote repository (e.g., on GitHub, GitLab, or Bitbucket) where you want to send your changes.
// git tag is used to create a tag in a Git repository.
// git push --tags is used to push tags from your local Git repository to the remote repository.
// git diff is used to see differences you made. You can scroll down by presssing enter. To quit, press q.
