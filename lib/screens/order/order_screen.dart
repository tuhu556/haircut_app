import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/order/components/body.dart';

import '../../enum.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = "/order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.order),
    );
  }
}
