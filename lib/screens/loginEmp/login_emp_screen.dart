import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/loginEmp/components/body.dart';

class LoginEmpScreen extends StatefulWidget {
  static String routeName = "/loginEmp";

  @override
  _LoginEmpScreenState createState() => _LoginEmpScreenState();
}

class _LoginEmpScreenState extends State<LoginEmpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
    );
  }
}
