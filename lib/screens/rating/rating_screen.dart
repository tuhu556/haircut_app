import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/screens/rating/thanks_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RatingScreen extends StatefulWidget {
  static String routeName = "/ratingScreen";

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  String comment = "";
  late double rate;
  late String email;
  late String apptID;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      apptID = arguments['apptID'];
    }
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
                              "Please rate our services",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          RatingBar.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    color: Colors.red,
                                  );
                                case 1:
                                  return Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent,
                                  );
                                case 2:
                                  return Icon(
                                    Icons.sentiment_neutral,
                                    color: Colors.amber,
                                  );
                                case 3:
                                  return Icon(
                                    Icons.sentiment_satisfied,
                                    color: Colors.lightGreen,
                                  );
                                case 4:
                                  return Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                              }
                              return Container();
                            },
                            onRatingUpdate: (rating) {
                              print(rating);
                              rate = rating;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                hintText: 'Review',
                                labelText: 'Review',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  comment = value;
                                });
                              },
                              maxLines: 3,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          RoundedButton(
                            color: AppColors.color3E3E3E,
                            textColor: Colors.white,
                            text: "Send",
                            press: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? token = prefs.getString("token");
                              email = prefs.getString("email")!;
                              final url =
                                  Uri.parse('${Api.url}/createFeedback');
                              final response = await http.post(
                                url,
                                body: jsonEncode(<String, dynamic>{
                                  'apptID': apptID,
                                  'comment': comment,
                                  'cusEmail': email,
                                  'rating': rate,
                                }),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Accept': 'application/json',
                                  'Authorization': '$token',
                                },
                              );
                              print(response.statusCode);
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                Navigator.pushNamed(
                                  context,
                                  ThanksScreen.routeName,
                                );
                              } else {
                                Flushbar(
                                  title: "Error",
                                  message: "Server Error",
                                  duration: Duration(seconds: 3),
                                ).show(context);
                              }
                            },
                          ),
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
