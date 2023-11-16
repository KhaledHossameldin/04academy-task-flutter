import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/routes.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/user_data/user_data_cubit.dart';
import 'screens/home.dart';
import 'screens/login.dart';

/// This class only handles routing to navigate between screens
class AppRouter {
  final _routes = Routes.instance;

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == _routes.login) {
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginScreen(),
        ),
      );
    }

    if (settings.name == _routes.home) {
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserDataCubit(),
          child: const HomeScreen(),
        ),
      );
    }

    return null;
  }
}
