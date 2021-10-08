import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/login/components/body.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
    );
  }
}
