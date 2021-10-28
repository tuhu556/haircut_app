import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';

import 'package:haircut_app/screens/order/order_screen.dart';

class ThanksScreen extends StatelessWidget {
  static String routeName = "/thanksScreen";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: SafeArea(
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
                        "Rate",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                        Center(
                            child: Image.asset("assets/images/thank-you.png")),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Center(
                          child: Text(
                            "Thank you for your review!",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                        Center(
                          child: RoundedButton(
                              text: "Done",
                              press: () {
                                Navigator.pushNamed(
                                  context,
                                  OrderScreen.routeName,
                                );
                              },
                              color: Color(0xFF151515),
                              textColor: Colors.white),
                        )
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
