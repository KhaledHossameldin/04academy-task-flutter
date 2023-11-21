import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/routes.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/notifications/notifications_cubit.dart';
import '../../utilities/extensions.dart';
import '../../utilities/validators.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<LoginCubit>().userData;
    return Scaffold(
      appBar: AppBar(title: const Text('User Screen')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user?.name}'),
            16.emptyHeight,
            Text('Email: ${user?.email}'),
            16.emptyHeight,
            _NotificationForm(
              formKey: _formKey,
              titleController: _titleController,
              bodyController: _bodyController,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: _SendNotificationButton(
                    formKey: _formKey,
                    titleController: _titleController,
                    bodyController: _bodyController,
                  )),
                  16.emptyWidth,
                  const Expanded(child: _LogoutButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          Navigator.pushReplacementNamed(
            context,
            Routes.instance.login,
          );
        }
      },
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () => context.read<LoginCubit>().logout(),
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
      ),
    );
  }
}

class _NotificationForm extends StatelessWidget {
  _NotificationForm({
    required this.formKey,
    required this.titleController,
    required this.bodyController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController bodyController;

  final _validators = Validators.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              validator: _validators.notificationTitle,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.notifications),
              ),
            ),
            8.emptyHeight,
            TextFormField(
              controller: bodyController,
              validator: _validators.notificationBody,
              decoration: const InputDecoration(
                labelText: 'Body',
                prefixIcon: Icon(Icons.notifications),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendNotificationButton extends StatelessWidget {
  const _SendNotificationButton({
    required this.formKey,
    required this.titleController,
    required this.bodyController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController bodyController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          state.message.showSnackbar(context, isError: true);
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (state is NotificationsLoading) return;
            final isValid = formKey.currentState?.validate() ?? false;
            if (isValid) {
              // This line means it will access the NotificationsCubit and call
              // the send method which will emit NotificationsLoading and
              // display a loading animation and send an HTTP request to
              // Firebase
              context.read<NotificationsCubit>().send(
                    title: titleController.text,
                    body: bodyController.text,
                  );
            }
          },
          // This line means if the state is loading (aka the request is still
          // working) display a loading animation otherwise display the normal
          // text (Send Notification)
          child: state is NotificationsLoading
              ? const CircularProgressIndicator.adaptive()
              : const Text('Send Notification'),
        );
      },
    );
  }
}
