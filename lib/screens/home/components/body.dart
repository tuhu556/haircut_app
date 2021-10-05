import 'package:flutter/material.dart';

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
                  top: 10.0, left: 30.0, right: 30.0, bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   child: Text(
                  //     "Home",
                  //     style: TextStyle(
                  //       fontSize: 30,
                  //       fontWeight: FontWeight.w800,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
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
                            // Navigator.pushNamed(
                            //   context,
                            //   BookingFormScreen.routeName,
                            // );
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
