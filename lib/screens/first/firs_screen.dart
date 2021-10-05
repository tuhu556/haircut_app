import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/login/login_screen.dart';
import 'package:haircut_app/screens/sign_up/sign_up_screen.dart';

class FirstScreen extends StatelessWidget {
  static String routeName = "/first";
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox(
                height: size.height * 0.05,
              ),
              RoundedButton(
                  text: "Login",
                  press: () {
                    Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    );
                  },
                  color: AppColors.color3E3E3E,
                  textColor: Colors.white),
              SizedBox(
                height: size.height * 0.02,
              ),
              RoundedButton(
                  text: "Sign Up",
                  press: () {
                    Navigator.pushNamed(
                      context,
                      SignUpScreen.routeName,
                    );
                  },
                  color: AppColors.color3E3E3E,
                  textColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
