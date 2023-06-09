import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:original/view/home.dart';
import 'package:original/view/login.dart';
import 'package:original/view/new_user.dart';
import 'package:original/view/update_page.dart';

import 'controller/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/update': (context) => UpdatePage(),
        '/create': (context) => NewUserPage(),
      },
    );
  }
}
