import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/booking/components/body.dart';

class BookingScreen extends StatelessWidget {
  static String routeName = "/booking";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Service",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.color3E3E3E,
      ),
      body: Body(),
    );
  }
}
