import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';
import 'package:haircut_app/constants/color.dart';

import '../../enum.dart';

class NotificationScreen extends StatelessWidget {
  static String routeName = "/notification";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.notification),
    );
  }
}
