import 'package:flutter/material.dart';
import 'auth_info.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Authorization',),
        ),
        body: AuthInfo(),
      ),
    );
  }
}
