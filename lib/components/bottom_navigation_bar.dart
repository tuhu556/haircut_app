import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/notification/notification_screen.dart';
import 'package:haircut_app/screens/order/order_screen.dart';
import 'package:haircut_app/screens/profile/profile_screen.dart';
import '../enum.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

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
                message: "Home",
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, HomeScreen.routeName),
                ),
              ),
              Tooltip(
                message: "Order",
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/shopping-list.svg",
                    color: MenuState.order == selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, OrderScreen.routeName);
                  },
                ),
              ),
              Tooltip(
                message: "Notification",
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/bell2.svg",
                    color: MenuState.notification == selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, NotificationScreen.routeName);
                  },
                ),
              ),
              Tooltip(
                message: "Profile",
                child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/User Icon.svg",
                      color: MenuState.profile == selectedMenu
                          ? AppColors.color000000
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    }),
              ),
            ],
          )),
    );
  }
}
