import 'package:flutter/material.dart';
import 'package:haircut_app/screens/profile/components/profile_menu.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 30.0, right: 30.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /////////////////////////////////////
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        "Hello...",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      ProfileMenu(
                        text: "My Account",
                        icon: "assets/icons/User Icon.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: "Settings",
                        icon: "assets/icons/Settings.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Help Center",
                        icon: "assets/icons/Question mark.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Log Out",
                        icon: "assets/icons/Log out.svg",
                        press: () {},
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 33),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
