import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/home/components/body.dart';

import '../../enum.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
