import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SignUpPage(),
      themeMode: ThemeMode.system,
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form fields
  String? _fullName;
  String? _email;
  String? _password;

  final GraphQLClient _client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink('http://127.0.0.1:4000/graphql'), // Replace with your GraphQL server URL
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            onSaved: (value) {
              _fullName = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Perform sign-up logic here
                // Typically, you would send the data to a server or perform authentication.
                signUp();
              }
            },
            child: Text('Sign Up'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Perform sign-in logic here
                // Typically, you would send the data to a server or perform authentication.
                signIn();
              }
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Future<void> signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final MutationOptions options = MutationOptions(
        document: gql('''
          mutation SignUp(\$password: String!, \$email: String!) {
            signUp(password: \$password, email: \$email) {
              token
            }
          }
        '''),
        variables: {
          'email': _email,
          'password': _password,
        },
      );

      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        // Handle error
        print('GraphQL Error: ${result.exception}');
      } else {
        // Handle successful sign-up
        final data = result.data!['signUp'];
        final token = data['token'];

        // You can store the userId and token or perform any other necessary actions.
        // print('User ID: $userId');
        print('Token: $token');
      }
    }
  }

  Future<void> signIn() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final MutationOptions options = MutationOptions(
        document: gql('''
          mutation SignIn(\$email: String!, \$password: String!) {
            signIn(email: \$email, password: \$password) {
              token
            }
          }
        '''),
        variables: {
          'email': _email,
          'password': _password,
        },
      );

      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        // Handle error
        print('GraphQL Error: ${result.exception}');
      } else {
        // Handle successful sign-up
        final data = result.data!['signIn'];
        final token = data['token'];

        // You can store the userId and token or perform any other necessary actions.
        // print('User ID: $userId');
        print('Token: $token');
      }
    }
  }


}
