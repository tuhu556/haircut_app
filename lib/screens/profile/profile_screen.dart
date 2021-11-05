import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';

import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/profile/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enum.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bool _isCustomer = false;

  // void _check() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString("user_type") == "cs") {
  //     _isCustomer = true;
  //   } else {
  //     _isCustomer = false;
  //   }
  // }

  // @override
  // void initState() {
  //   _check();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
