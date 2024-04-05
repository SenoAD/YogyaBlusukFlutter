import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/account_usecase.dart';
import 'package:yogya_blusuk/Presentation/Screens/home_screen.dart';
import 'package:yogya_blusuk/Presentation/Screens/register_screen.dart';

import '../../Data/Datasources/api_datasource.dart';
import '../../Data/Repositories/api_repositories.dart';

class LoginPage extends StatelessWidget {
  final AccountRepository accountRepository;

  const LoginPage({Key? key, required this.accountRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/login_image.jpg', // Path to your image asset
              height: 200, // Adjust the height as needed
              width: double.maxFinite, // Set width to max available width
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            LoginForm(accountRepository: accountRepository),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final AccountRepository accountRepository;

  const LoginForm({Key? key, required this.accountRepository}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Call the login method of the repository
                try {
                  UserWithToken userWithToken =
                  await widget.accountRepository.loginToken(username, password);
                  var box = await Hive.openBox('userBox');
                  await box.put('token', userWithToken.token);
                  await box.put('userId', userWithToken.userId);
                  // Successful login, do something with the user data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(placeRepository: PlaceRepositoryImpl(ApiDataSource()),
                                                       vacationPlanRepository: VacationPlanRepositoryImpl(ApiDataSource()))
                    ),
                  );
                } catch (e) {
                  // Handle login error
                  print('Login failed: $e');
                  // print('Login failed: $username');
                }
              }
            },
            child: Text('Login'),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage(accountRepository: AccountRepositoryImpl(ApiDataSource()))),
              );
            },
            child: Text(
              'Register Account',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.purple,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
