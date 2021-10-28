import 'package:flutter/widgets.dart';
import 'package:haircut_app/screens/booking/booking_screen.dart';
import 'package:haircut_app/screens/cart/cart_screen.dart';
import 'package:haircut_app/screens/datetime/datetime_screen.dart';
import 'package:haircut_app/screens/first/firs_screen.dart';
import 'package:haircut_app/screens/forgot_password/change_password_screen.dart';
import 'package:haircut_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:haircut_app/screens/forgot_password/password_success_screen.dart';
import 'package:haircut_app/screens/forgot_password/verify_code_forgot_pass_screen.dart';
import 'package:haircut_app/screens/forgot_password/verify_code_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/screens/login/login_screen.dart';
import 'package:haircut_app/screens/notification/notification_screen.dart';
import 'package:haircut_app/screens/order/order_screen.dart';
import 'package:haircut_app/screens/profile/profile_screen.dart';
import 'package:haircut_app/screens/rating/rating_screen.dart';
import 'package:haircut_app/screens/rating/thanks_screen.dart';
import 'package:haircut_app/screens/sign_up/sign_up_screen.dart';
import 'package:haircut_app/screens/success_booking/success_booking_screen.dart';

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
  DatetimeScreen.routeName: (context) => DatetimeScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  SuccessBookingScreen.routeName: (context) => SuccessBookingScreen(),
  PasswordSuccessScreen.routeName: (context) => PasswordSuccessScreen(),
  VerifyCodeForgotPassScreen.routeName: (context) =>
      VerifyCodeForgotPassScreen(),
  RatingScreen.routeName: (context) => RatingScreen(),
  ThanksScreen.routeName: (context) => ThanksScreen(),
};
