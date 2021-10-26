import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/success_booking/components/body.dart';

class SuccessBookingScreen extends StatelessWidget {
  static String routeName = "/successBooking";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      backgroundColor: AppColors.color3E3E3E,
    );
  }
}
