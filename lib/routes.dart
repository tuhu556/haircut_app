import 'package:flutter/widgets.dart';
import 'package:haircut_app/screens/booking/booking_screen.dart';
import 'package:haircut_app/screens/first/firs_screen.dart';
import 'package:haircut_app/screens/forgot_password/change_password_screen.dart';
import 'package:haircut_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:haircut_app/screens/forgot_password/verify_code_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/login/login_screen.dart';
import 'package:haircut_app/screens/notification/notification_screen.dart';
import 'package:haircut_app/screens/order/order_screen.dart';
import 'package:haircut_app/screens/profile/profile_screen.dart';
import 'package:haircut_app/screens/sign_up/sign_up_screen.dart';

import 'screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  FirstScreen.routeName: (context) => FirstScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  VerifyCodeScreen.routeName: (context) => VerifyCodeScreen(),
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  BookingScreen.routeName: (context) => BookingScreen(),
};
