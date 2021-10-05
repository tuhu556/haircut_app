import 'package:flutter/widgets.dart';
import 'package:haircut_app/screens/first/firs_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/login/login_screen.dart';
import 'package:haircut_app/screens/sign_up/sign_up_screen.dart';

import 'screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  FirstScreen.routeName: (context) => FirstScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
};
