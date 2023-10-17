import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/ports/inputPorts/get_reminders_of_current_user_use_case.dart';
import 'home.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the home screen after sign-up
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(context.read<GetRemindersOfCurrentUserUseCase>())),
            );
          },
          child: const Text('Sign Up'),
        ),
      ),
    );
  }
}
