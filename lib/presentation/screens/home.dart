import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _validators = Validators.instance;

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
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              validator: _validators.notificationTitle,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                prefixIcon: Icon(Icons.notifications),
                              ),
                            ),
                            8.emptyHeight,
                            TextFormField(
                              controller: _bodyController,
                              validator: _validators.notificationBody,
                              decoration: const InputDecoration(
                                labelText: 'Body',
                                prefixIcon: Icon(Icons.notifications),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    32.emptyHeight,
                    BlocConsumer<NotificationsCubit, NotificationsState>(
                      listener: (context, state) {
                        if (state is NotificationsError) {
                          state.message.showSnackbar(context, isError: true);
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (state is NotificationsLoading) return;
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              context.read<NotificationsCubit>().send(
                                    title: _titleController.text,
                                    body: _bodyController.text,
                                  );
                            }
                          },
                          child: state is NotificationsLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text('Send Notification'),
                        );
                      },
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
