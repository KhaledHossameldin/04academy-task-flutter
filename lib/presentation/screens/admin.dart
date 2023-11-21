import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/login/login_cubit.dart';
import '../../cubits/users/users_cubit.dart';
import '../widgets/reload_button.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
      appBar: AppBar(title: const Text('Admin Screen')),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UsersLoading:
              return const Center(child: CircularProgressIndicator());

            case UsersLoaded:
              final users = (state as UsersLoaded).users;
              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Role')),
                  ],
                  rows: users
                      .map((user) => DataRow(cells: [
                            DataCell(Text(user.id.toString())),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(Text(
                              '${user.isSuperAdmin ? 'super ' : ''}${user.role.name}',
                            )),
                          ]))
                      .toList(),
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
