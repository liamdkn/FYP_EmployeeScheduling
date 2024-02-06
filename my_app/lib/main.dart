/*
* Author: Liam Durkan 
* Date:
* Licence: GPL3
* Brief: This is the main fucntion and the launch page. 
*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/views/CreateRoster.dart';
import 'package:my_app/views/GenerateRosterScreen.dart';
import 'package:my_app/widgets/navbar.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Employee Scheduling App'),
          backgroundColor: Color.fromARGB(255, 74, 62, 207),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Launch Page',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
