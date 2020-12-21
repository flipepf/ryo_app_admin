import 'package:flutter/material.dart';
import 'package:ryo_app_admin/pages/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.redAccent
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

