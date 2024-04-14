import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/views/splash_screen.dart';
import 'package:my_app/views/user_auth/user_auth_provider.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';
import 'package:my_app/views/main/main_screen.dart';
import 'package:my_app/views/user_auth/user_signup_page.dart';
import 'package:provider/provider.dart';
import 'package:my_app/controllers/MenuAppController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthUserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Scheduling App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          canvasColor: secondaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
        ),
        routes: {
          '/': (context) => SplashScreen(
                child: LoginPage(),
              ),
          '/login': (context) => LoginPage(),
          '/signUp': (context) => SignUpPage(),
          '/home': (context) => MainScreen(),
        },
      ),
    );
  }
}
