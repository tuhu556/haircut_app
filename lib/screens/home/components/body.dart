import 'package:flutter/material.dart';
import 'package:haircut_app/screens/booking/booking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);
  void getCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getCustomer();
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Home",
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
                      Center(
                        child: GestureDetector(
                          child: Image(
                            image: AssetImage("assets/images/Book.png"),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              BookingScreen.routeName,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Most farvorite services",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset("assets/images/Haircut.png"),
                              ),
                              GestureDetector(
                                child:
                                    Image.asset("assets/images/HairDying.png"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                    "assets/images/HairCurling.png"),
                              ),
                              GestureDetector(
                                child:
                                    Image.asset("assets/images/HairCare.png"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset("assets/images/Combo1.png"),
                              ),
                              GestureDetector(
                                child: Image.asset("assets/images/Combo2.png"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
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
