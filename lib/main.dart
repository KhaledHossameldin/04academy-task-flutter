import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';
import 'presentation/app_router.dart';

void main() async {
  // This line is added to ensure that the Flutter framework and the host
  // platform (Android or iOS) are binded to avoid any pottential errors in the
  // future
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '04Academy Task',
      theme: themeData,
      initialRoute: Routes.instance.login,
      onGenerateRoute: AppRouter().onGenerateRoute,
    );
  }
}
