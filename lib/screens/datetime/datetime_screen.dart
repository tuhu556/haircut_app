import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/datetime/components/body.dart';

class DatetimeScreen extends StatelessWidget {
  static String routeName = "/datetime";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
    );
  }
}