import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/booking/components/body.dart';
import 'package:haircut_app/screens/booking/components/body2.dart';
import 'package:haircut_app/screens/datetime/datetime_screen.dart';

class BookingScreen extends StatelessWidget {
  static String routeName = "/booking";

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          "Select Service",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {
              Navigator.pushNamed(context, DatetimeScreen.routeName);
            },
            child: const Text('Next'),
          ),
        ],
        backgroundColor: AppColors.color3E3E3E,
      ), */
      body: Body(),
      backgroundColor: AppColors.color3E3E3E,
    );
  }
}
