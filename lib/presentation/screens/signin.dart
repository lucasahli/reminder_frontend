import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/sign_in_result.dart';
import '../../core/ports/inputPorts/sign_in_use_case.dart';

class SignInScreen extends StatefulWidget {
  final SignInUseCase _signInUseCase;

  const SignInScreen(this._signInUseCase, {Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;

  void _signIn() async {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
    // Call the sign-in use case
    final signInResult = await widget._signInUseCase
        .execute(_emailController.text, _passwordController.text);
    if (signInResult is SignInSuccess) {
      // Navigate to the home screen after sign-in
      if (!mounted) return;
      // if (!context.mounted) return;
      context.go('/');
    } else if (signInResult is SignInProblem) {
      for (final invalidInput in signInResult.invalidInputs) {
        if (invalidInput.field == 'EMAIL') {
          setState(() {
            _emailError = invalidInput.message;
          });
        } else if (invalidInput.field == 'PASSWORD') {
          setState(() {
            _passwordError = invalidInput.message;
          });
        }
      }
    }
    // For example, you might call a method on your authentication service
    // print('Email: ${_emailController.text}');
    // print('Password: ${_passwordController.text}');
    // YourAuthService.signIn(_emailController.text, _passwordController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction:
                    TextInputAction.next, // Moves focus to next input
              ),

              const SizedBox(height: 16.0), // Add spacing between fields
              // Password input field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  errorText: _passwordError,
                ),
                obscureText: true,
                // Hide the password
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                // Indicates completion
                onFieldSubmitted: (value) {
                  // This is called when the user presses "Enter" on the keyboard
                  _signIn();
                },
              ),
              const SizedBox(height: 16.0), // Add spacing between fields
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
