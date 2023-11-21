import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/routes.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/users/users_cubit.dart';
import '../../utilities/extensions.dart';
import '../widgets/reload_button.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _routes = Routes.instance;

  @override
  void initState() {
    final isSuperAdmin =
        context.read<LoginCubit>().userData?.isSuperAdmin ?? false;
    context.read<UsersCubit>().fetch(withAdmins: isSuperAdmin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin =
        context.read<LoginCubit>().userData?.isSuperAdmin ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldReload = await Navigator.pushNamed<bool>(
                    context,
                    _routes.userDetails,
                  ) ??
                  false;
              if (!context.mounted) return;
              if (shouldReload) {
                context.read<UsersCubit>().fetch(withAdmins: isSuperAdmin);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UsersLoading:
              return const Center(child: CircularProgressIndicator());

            case UsersLoaded:
              final users = (state as UsersLoaded).users;
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                    ],
                    rows: users
                        .map((user) => DataRow(cells: [
                              DataCell(
                                Text(user.name),
                                onTap: () async {
                                  if (user.isSuperAdmin && !isSuperAdmin) {
                                    'Cannot change Super Admin info'
                                        .showSnackbar(context, isError: true);
                                    return;
                                  }
                                  final shouldReload =
                                      await Navigator.pushNamed<bool>(
                                            context,
                                            _routes.userDetails,
                                            arguments: user,
                                          ) ??
                                          false;
                                  if (!context.mounted) return;
                                  if (shouldReload) {
                                    context
                                        .read<UsersCubit>()
                                        .fetch(withAdmins: isSuperAdmin);
                                  }
                                },
                              ),
                              DataCell(Text(user.email)),
                              DataCell(Text(
                                '${user.isSuperAdmin ? 'super ' : ''}${user.role.name}',
                              )),
                            ]))
                        .toList(),
                  ),
                ),
              );

            case UsersError:
              return ReloadButton(
                message: (state as UsersError).message,
                onTap: () =>
                    context.read<UsersCubit>().fetch(withAdmins: isSuperAdmin),
              );

            default:
              return const Material();
          }
        },
      ),
    );
  }
}
