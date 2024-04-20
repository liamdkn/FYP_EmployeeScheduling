import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/views/user_auth/componenets/user_auth_widget.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';
import 'package:provider/provider.dart';
import 'package:my_app/controllers/MenuAppController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Scheduling App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        canvasColor: secondaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => AuthWidget(),
        //"/home": (context) => MainScreen(),
        "/login": (context) => LoginPage(),
      },
    );
  }
}
