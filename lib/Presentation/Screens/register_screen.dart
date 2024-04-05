import 'package:flutter/material.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/account_usecase.dart';
import 'package:yogya_blusuk/Presentation/Screens/home_screen.dart';

import '../../Data/Datasources/api_datasource.dart';
import '../../Data/Repositories/api_repositories.dart';
import 'login_screen.dart';

class RegisterPage extends StatelessWidget {
  final AccountRepository accountRepository;

  const RegisterPage({Key? key, required this.accountRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterForm(accountRepository: accountRepository),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final AccountRepository accountRepository;

  const RegisterForm({Key? key, required this.accountRepository}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (value == null) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _rePasswordController,
            decoration: InputDecoration(labelText: 'Re-enter Password'),
            obscureText: true,
            validator: (value) {
              if (value == null) {
                return 'Please re-enter your password';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null) {
                return 'Please enter your email';
              } else if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                // Perform registration
                try {
                  await widget.accountRepository.register(
                    UserCreate(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      username: _usernameController.text,
                      password: _passwordController.text,
                      email: _emailController.text,
                    ),
                  );
                  // Navigate to home screen after successful registration
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(accountRepository: AccountRepositoryImpl(ApiDataSource()))),
                  );
                } catch (e) {
                  // Handle registration error
                  print('Registration failed: $e');
                }
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
