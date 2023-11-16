import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/routes.dart';
import '../../cubits/cubit/logout_cubit.dart';
import '../../cubits/notifications/notifications_cubit.dart';
import '../../cubits/user_data/user_data_cubit.dart';
import '../../data/enums/user_role.dart';
import '../../utilities/extensions.dart';
import '../../utilities/validators.dart';
import '../widgets/reload_button.dart';

/// This screen only use at the moment is to display fetch and display user data
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    // The UserDataCubit is called in initState to fetch the data once the
    // screen is opened and it will automatically display loading animation and
    // fetch the data and diplay it correctly
    context.read<UserDataCubit>().fetch();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: BlocBuilder<UserDataCubit, UserDataState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UserDataLoading:
              return const Center(child: CircularProgressIndicator.adaptive());

            case UserDataLoaded:
              final data = (state as UserDataLoaded).data;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Name: ${data.name}',
                      style: textTheme.headlineMedium,
                    ),
                    16.emptyHeight,
                    Text(
                      'This account is ${data.role == UserRole.admin ? 'an admin' : 'a user'}',
                      style: textTheme.headlineSmall,
                    ),
                    32.emptyHeight,
                    _NotificationForm(
                      formKey: _formKey,
                      titleController: _titleController,
                      bodyController: _bodyController,
                    ),
                    32.emptyHeight,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _SendNotificationButton(
                              formKey: _formKey,
                              titleController: _titleController,
                              bodyController: _bodyController,
                            ),
                          ),
                          16.emptyWidth,
                          Expanded(
                            flex: 2,
                            child: _LogoutButton(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            case UserDataError:
              return ReloadButton(
                message: (state as UserDataError).message,
                onTap: () => context.read<UserDataCubit>().fetch(),
              );

            default:
              return const Material();
          }
        },
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  _LogoutButton();

  final _routes = Routes.instance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoaded) {
          Navigator.pushReplacementNamed(context, _routes.login);
          return;
        }
        if (state is LogoutError) {
          state.message.showSnackbar(context, isError: true);
          return;
        }
      },
      builder: (context, state) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          // This line means it will access the LogoutCubit and the logout
          // method which will emit LogoutLoading and display a loading
          // animation and send an HTTP request to Firebase
          onPressed: () => context.read<LogoutCubit>().logout(),
          icon: const Icon(Icons.logout),
          // This line means if the state is loading (aka the request
          // is still working) display a loading animation otherwise
          // display the normal text (Logout)
          label: state is LogoutLoading
              ? const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                )
              : const Text('Logout'),
        );
      },
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
