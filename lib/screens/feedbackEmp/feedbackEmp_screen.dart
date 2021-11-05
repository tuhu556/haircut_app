import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bart_Emp.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/feedbackEmp/components/body.dart';

import '../../enumEmp.dart';

class FeedbackEmpScreen extends StatelessWidget {
  static String routeName = "/feedbackEmp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
      bottomNavigationBar: BottomNavBarEmp(selectedMenu: MenuState.feedback),
    );
  }
}
