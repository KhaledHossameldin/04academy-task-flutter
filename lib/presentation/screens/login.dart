import 'dart:developer';

import 'package:flutter/material.dart';

import '../../utilities/extensions.dart';
import '../../utilities/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _validators = Validators.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      // The login form which includes an email textfield, a password
      // textfield and a submit button which all use Validators classes to
      // validate their values
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: _validators.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              16.emptyHeight,
              TextFormField(
                controller: _passwordController,
                validator: _validators.password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              32.emptyHeight,
              ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    log({'email': _emailController.text}.toString());
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
