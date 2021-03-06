import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bart_Emp.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/profileEmp/components/body.dart';

import '../../enumEmp.dart';

class ProfileEmpScreen extends StatelessWidget {
  static String routeName = "/profileEmp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
      bottomNavigationBar: BottomNavBarEmp(selectedMenu: MenuState.profile),
    );
  }
}
