import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'constants/routes.dart';
import 'cubits/login/login_cubit.dart';
import 'data/services/repository.dart';
import 'firebase_options.dart';
import 'presentation/app_router.dart';

void main() async {
  // This line is added to ensure that the Flutter framework and the host
  // platform (Android or iOS) are binded to avoid any pottential errors in the
  // future
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // This line sets orientation options to portrait only as I do not have a
  //design and I am not that good in UI/UX so I set it to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // This line initializes Firebase in the application
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Repository.instance.initNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This variable has all the standard themes in the entire application
    final themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '04Academy Task',
        theme: themeData,
        initialRoute: Routes.instance.login,
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}
