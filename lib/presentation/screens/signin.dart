import 'package:flutter/material.dart';
import '../../core/ports/inputPorts/sign_in_use_case.dart';
import 'home.dart';

import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  final SignInUseCase _signInUseCase;

  SignInScreen(this._signInUseCase, {Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextFormField(
              onChanged: (value) {
                setState(() {
                  email = value; // Store the email input
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16.0), // Add spacing between fields
            // Password input field
            TextFormField(
              onChanged: (value) {
                setState(() {
                  password = value; // Store the password input
                });
              },
              obscureText: true, // Hide the password
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 16.0), // Add spacing between fields
            ElevatedButton(
              onPressed: () async {
                // Call the sign-in use case
                final success = await widget._signInUseCase.execute(email, password);
                if (success) {
                  // Navigate to the home screen after sign-in
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } else {
                  print("Could not sign in!!!");
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
