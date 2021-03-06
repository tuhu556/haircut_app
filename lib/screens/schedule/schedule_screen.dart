import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bart_Emp.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/schedule/components/body.dart';

import '../../enumEmp.dart';

class ScheduleScreen extends StatelessWidget {
  static String routeName = "/schedule";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.green,
      ),
      child: Scaffold(
        backgroundColor: AppColors.color3E3E3E,
        body: Body(),
        bottomNavigationBar: BottomNavBarEmp(selectedMenu: MenuState.schedule),
      ),
    );
  }
}
