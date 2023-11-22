import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/login/login_cubit.dart';
import '../../cubits/user_details/user_details_cubit.dart';
import '../../data/enums/user_role.dart';
import '../../data/models/user_data.dart';
import '../../utilities/extensions.dart';
import '../../utilities/validators.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, this.userData});

  final UserData? userData;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isAdmin = ValueNotifier(false);

  final _validators = Validators.instance;

  @override
  void initState() {
    if (widget.userData != null) {
      _nameController.text = widget.userData!.name;
      _emailController.text = widget.userData!.email;
      _passwordController.text = widget.userData!.password;
      _isAdmin.value = widget.userData!.role == UserRole.admin;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isAdmin.dispose();
    super.dispose();
  }

  void handleUser() {
    final userData = UserData(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      role: _isAdmin.value ? UserRole.admin : UserRole.user,
    );
    final cubit = context.read<UserDetailsCubit>();
    if (widget.userData == null) {
      cubit.add(userData);
      return;
    }
    cubit.updateUser(userData, widget.userData!.email);
  }

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin =
        context.read<LoginCubit>().userData?.isSuperAdmin ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('User Details Screen')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: _validators.name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              16.emptyHeight,
              TextFormField(
                controller: _emailController,
                validator: _validators.email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              16.emptyHeight,
              TextFormField(
                controller: _passwordController,
                validator: _validators.password,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (isSuperAdmin)
                Column(
                  children: [
                    16.emptyHeight,
                    ValueListenableBuilder(
                      valueListenable: _isAdmin,
                      builder: (context, value, child) =>
                          SwitchListTile.adaptive(
                        title: const Text('Admin or Not?'),
                        value: value,
                        onChanged: (value) => _isAdmin.value = value,
                      ),
                    ),
                  ],
                ),
              32.emptyHeight,
              BlocConsumer<UserDetailsCubit, UserDetailsState>(
                listener: (context, state) {
                  if (state is UserDetailsLoaded) {
                    Navigator.pop(context, true);
                    return;
                  }
                  if (state is UserDetailsError) {
                    state.message.showSnackbar(context, isError: true);
                    return;
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              handleUser();
                            }
                          },
                          child: state is UserDetailsLoading
                              ? const CircularProgressIndicator.adaptive()
                              : Text(
                                  '${widget.userData == null ? 'Add' : 'Update'} User',
                                ),
                        ),
                      ),
                      if (widget.userData != null) 16.emptyWidth,
                      if (widget.userData != null)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<UserDetailsCubit>().deleteUser(
                                    widget.userData!.email,
                                  );
                            },
                            child: state is UserDetailsDeleting
                                ? const CircularProgressIndicator.adaptive()
                                : const Text('Delete User'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
