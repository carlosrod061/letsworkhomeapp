import 'package:flutter/material.dart';
import 'package:letsworkhomeapp/screens/login_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
