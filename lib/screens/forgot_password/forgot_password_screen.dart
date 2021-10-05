import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/forgot_password/email_form.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgotPassword";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: KeyboardDismisser(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0, left: 30.0, right: 30.0, bottom: 25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 25.0),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: size.height * 0.20,
                          width: size.width * 0.55,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Text(
                            "Please enter your email and we will send \nyou a code to return to your account",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          EmailForm(),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
        ),
      ),
    );
  }
}
