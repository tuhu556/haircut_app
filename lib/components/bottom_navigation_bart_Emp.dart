import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/feedbackEmp/feedbackEmp_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/notification/notification_screen.dart';
import 'package:haircut_app/screens/order/order_screen.dart';
import 'package:haircut_app/screens/profile/profile_screen.dart';
import 'package:haircut_app/screens/profileEmp/profileEmp_screen.dart';
import 'package:haircut_app/screens/schedule/schedule_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../enumEmp.dart';

class BottomNavBarEmp extends StatefulWidget {
  const BottomNavBarEmp({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  State<BottomNavBarEmp> createState() => _BottomNavBarEmpState();
}

class _BottomNavBarEmpState extends State<BottomNavBarEmp> {
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.colorECF0F1,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(40),
        //   topRight: Radius.circular(40),
        // ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Tooltip(
                message: "Schedule",
                child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Shop Icon.svg",
                      color: MenuState.schedule == widget.selectedMenu
                          ? AppColors.color000000
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                          if (MenuState.schedule != widget.selectedMenu)
                            Navigator.pushNamed(
                                context, ScheduleScreen.routeName),
                        }),
              ),
              Tooltip(
                message: "Feedback",
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/shopping-list.svg",
                    color: MenuState.feedback == widget.selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    if (MenuState.feedback != widget.selectedMenu)
                      Navigator.pushNamed(context, FeedbackEmpScreen.routeName);
                  },
                ),
              ),
              Tooltip(
                message: "Profile",
                child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/User Icon.svg",
                      color: MenuState.profile == widget.selectedMenu
                          ? AppColors.color000000
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileEmpScreen.routeName);
                    }),
              ),
            ],
          )),
    );
  }
}
