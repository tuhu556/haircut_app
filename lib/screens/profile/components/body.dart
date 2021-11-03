import 'package:flutter/material.dart';
import 'package:haircut_app/screens/profile/components/edit_profile.dart';
import 'package:haircut_app/screens/profile/components/profile_menu.dart';
import 'package:haircut_app/screens/profile/components/update_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString("name") ?? "";

    return str;
  }

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
                  top: 10.0, left: 30.0, right: 30.0, bottom: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 24,
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
                      Container(
                        child: FutureBuilder(
                          future: getUserName(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) return Container();
                            final String? name = snapshot.data;
                            return Text(
                              "Hello " + name!,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w700),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      ProfileMenu(
                        text: "My Account",
                        icon: "assets/icons/User Icon.svg",
                        press: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()))
                        },
                      ),
                      ProfileMenu(
                        text: "Change Password",
                        icon: "assets/icons/Settings.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePassword()));
                        },
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
                        press: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          Navigator.popUntil(
                              context, ModalRoute.withName('/login'));
                        },
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 33),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
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
