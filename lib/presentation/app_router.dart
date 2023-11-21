import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/routes.dart';
import '../cubits/users/users_cubit.dart';
import 'screens/admin.dart';
import 'screens/user.dart';
import 'screens/login.dart';

/// This class only handles routing to navigate between screens
class AppRouter {
  final _routes = Routes.instance;

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == _routes.login) {
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    }

    if (settings.name == _routes.user) {
      return MaterialPageRoute(
        builder: (context) => const UserScreen(),
      );
    }

    if (settings.name == _routes.admin) {
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UsersCubit(),
          child: const AdminScreen(),
        ),
      );
    }

    return null;
  }
}
