import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/notification/notification_screen.dart';
import 'package:haircut_app/screens/order/order_screen.dart';
import 'package:haircut_app/screens/profile/profile_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../enum.dart';

class BadgeNotification with ChangeNotifier {
  int num = 0;

  getNumber() => num;

  setNumber(int num) {
    this.num = num;
    notifyListeners();
  }

  Future<void> getTotalNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final url = Uri.parse(
        '${Api.url}/getNotiByCusEmail?cusEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    int index = 0;
    for (var _ in jsonData) {
      index++;
    }
    num = index;
    notifyListeners();
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final notificationModel = Provider.of<BadgeNotification>(context);
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
                    color: MenuState.home == widget.selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                    if (MenuState.home != widget.selectedMenu)
                      Navigator.pushNamed(context, HomeScreen.routeName),
                  }
                      
                ),
              ),
              Tooltip(
                message: "Order",
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/shopping-list.svg",
                    color: MenuState.order == widget.selectedMenu
                        ? AppColors.color000000
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    if (MenuState.order != widget.selectedMenu)
                      Navigator.pushNamed(context, OrderScreen.routeName);
                  },
                ),
              ),
              Stack(
                children: [
                  Tooltip(
                    message: "Notification",
                    child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/bell2.svg",
                        color: MenuState.notification == widget.selectedMenu
                            ? AppColors.color000000
                            : inActiveIconColor,
                      ),
                      onPressed: () {
                        if (MenuState.notification != widget.selectedMenu)
                          Navigator.pushNamed(context, NotificationScreen.routeName);
                      },
                    ),
                  ),
                  if (notificationModel.getNumber() != 0) ...[
                    Positioned(
                      top: 3,
                      right: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                        alignment: Alignment.center,
                        child: Text(notificationModel.getNumber().toString(), style: new TextStyle(color: Colors.white, fontSize: 12, ), textAlign: TextAlign.center),
                      ),
                    )
                  ]
                ],
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
                      if (MenuState.profile != widget.selectedMenu)
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                    }),
              ),
            ],
          )),
    );
  }
}
