import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/user_data/user_data_cubit.dart';
import '../../data/enums/user_role.dart';
import '../../utilities/extensions.dart';
import '../widgets/reload_button.dart';

/// This screen only use at the moment is to display fetch and display user data
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // The UserDataCubit is called in initState to fetch the data once the
    // screen is opened and it will automatically display loading animation and
    // fetch the data and diplay it correctly
    context.read<UserDataCubit>().fetch();
    super.initState();
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
