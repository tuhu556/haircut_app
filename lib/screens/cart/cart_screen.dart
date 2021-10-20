import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/cart/components/body.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
    );
  }
}
