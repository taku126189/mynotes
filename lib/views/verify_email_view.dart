// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes4/constants/routes.dart';
import 'package:mynotes4/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // VerifyEmailView has to have scaffold because you removed scaffold from homepage.
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "we've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you haven't received a verification email, press the button below."),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();

              // if you put user.sendEmailVerification(), Flutter says The method 'sendEmailVerification' can't be unconditionally invoked because the receiver can be 'null'.
              // So, you need to conditionally access this function.
              // This function is a future. Calling a function that returns Future<void> does not invoke the future. It only tells the function to return the future.
              // So if you want the future to be executed, you need to await. You need to add await and async.
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          ) // child should be put at the end.
        ],
      ),
    );
  }
}
