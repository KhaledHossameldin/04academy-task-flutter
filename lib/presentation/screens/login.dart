import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/routes.dart';
import '../../cubits/login/login_cubit.dart';
import '../../data/enums/user_role.dart';
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
      // The login form which includes an email textfield, a password
      // textfield and a submit button which all use Validators classes to
      // validate their values
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LoginForm(
            formKey: _formKey,
            emailController: _emailController,
            validators: _validators,
            passwordController: _passwordController,
          ),
          32.emptyHeight,
          _LoginButton(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.validators,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final Validators validators;
  final TextEditingController passwordController;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _isHidden = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: widget.emailController,
              validator: widget.validators.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            8.emptyHeight,
            // ValueListenableBuilder is a special widget that is used to
            // re-render what is inside it only when the value of the assigned
            // ValueNotifier changes.
            // I have used it here as changing visibility of password will not
            // affect anthing but the password textfield so it will lead to
            // better performance if I re-render the password textfield only
            ValueListenableBuilder(
              valueListenable: _isHidden,
              builder: (context, value, child) => TextFormField(
                controller: widget.passwordController,
                validator: widget.validators.password,
                obscureText: value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () => _isHidden.value = !_isHidden.value,
                    icon: Icon(
                      value ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  _LoginButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final _routes = Routes.instance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoaded) {
          // This if statement decides whether to navigate to user screen or
          // admin screen based on if the user is an admin or not
          if (state.userData.role == UserRole.admin) {
            Navigator.pushReplacementNamed(context, _routes.admin);
            return;
          }
          Navigator.pushReplacementNamed(context, _routes.user);
          return;
        }
        if (state is LoginError) {
          state.message.showSnackbar(context, isError: true);
          return;
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (state is LoginLoading) return;
            final isValid = formKey.currentState?.validate() ?? false;
            if (isValid) {
              // This line means it will access the LoginCubit and
              // call the login method which will emit LoginLoading
              // and display a loading animation and send an HTTP
              // request to Firebase
              context.read<LoginCubit>().login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
            }
          },
          // This line means if the state is loading (aka the request
          // is still working) display a loading animation otherwise
          // display the normal text (Login)
          child: state is LoginLoading
              ? const CircularProgressIndicator.adaptive()
              : const Text('Login'),
        );
      },
    );
  }
}
