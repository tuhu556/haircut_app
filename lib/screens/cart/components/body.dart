import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/screens/success_booking/success_booking_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Appointment;
    return BookingViews(
      appointment: args,
    );
  }
}

class BookingViews extends StatefulWidget {
  final Appointment appointment;
  const BookingViews({Key? key, required this.appointment}) : super(key: key);

  @override
  _BookingViewsState createState() => _BookingViewsState();
}

class _BookingViewsState extends State<BookingViews> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi');
  late Appointment _appointment;

  List<Service>? _selectedServices = [];
  DateTime? bookingDate;
  DateTime? startTime;
  String? email;
  int? totalDuration = 0;
  double? totalPrice = 0;
  String _date = "";
  String _time = "";
  String? status = "";
  late String note = "";
  @override
  void initState() {
    email = widget.appointment.cusEmail;
    bookingDate = widget.appointment.date;
    startTime = widget.appointment.startTime;
    totalDuration = widget.appointment.totalDuration;
    totalPrice = widget.appointment.totalPrice;
    _selectedServices = widget.appointment.serives;
    status = widget.appointment.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _date = DateFormat('dd MMM, yyyy').format(bookingDate!);
    _time = DateFormat('H:mm').format(startTime!);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
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
                      "Your Booking",
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
            Expanded(
              child: Container(
                child: KeyboardDismisser(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Center(
                          child: Text(
                            "$email",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                        ),
                        // Center(
                        //   child: Text(
                        //     "Phone",
                        //     style: TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w500),
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Booking Date",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(height: 2, color: AppColors.colorDDDDDD),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "$_date",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "$_time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Total duration",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "$totalDuration min",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Services",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(height: 2, color: AppColors.colorDDDDDD),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _selectedServices?.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  _selectedServices![index]
                                      .serviceName
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Text(
                                  "${currencyFormatter.format(_selectedServices![index].price)}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total Price",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Text(
                              "${currencyFormatter.format(totalPrice)}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            labelText: 'Note',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              note = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: RoundedButton(
                                text: "Book now",
                                press: () async {
                                  print('note:' + note);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? token = prefs.getString("token");
                                  print(token);
                                  final url =
                                      Uri.parse('${Api.url}/createAppointment');

                                  Map<String, String> requestHeaders = {
                                    'Authorization': '$token'
                                  };
                                  // Map<String, dynamic> body = {
                                  //   'cusEmail': email,
                                  //   'date': bookingDate!.toIso8601String(),
                                  //   'description': note,
                                  //   'listService': _selectedServices,
                                  //   'startTime': startTime!.toIso8601String(),
                                  //   'status': status,
                                  //   'totalDuration': totalDuration,
                                  //   'totalPrice': totalPrice
                                  // };
                                  final response = await http.post(url,
                                      body: jsonEncode(<String, dynamic>{
                                        'cusEmail': email,
                                        'date': bookingDate!.toIso8601String(),
                                        'description': note,
                                        'listService': _selectedServices,
                                        'startTime':
                                            startTime!.toIso8601String(),
                                        'status': "ON PROCESS",
                                        'totalDuration': totalDuration,
                                        'totalPrice': totalPrice
                                      }),
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Accept': 'application/json',
                                        'Authorization': '$token',
                                      });

                                  if (response.statusCode == 201) {
                                    Navigator.pushNamed(
                                      context,
                                      SuccessBookingScreen.routeName,
                                    );
                                  } else if (response.statusCode == 500) {
                                    Flushbar(
                                      title: "Error",
                                      message: "Server Error",
                                      duration: Duration(seconds: 4),
                                    ).show(context);
                                  } else {
                                    Flushbar(
                                      title: "Error",
                                      message:
                                          "Something is wrong, please try again!",
                                      duration: Duration(seconds: 4),
                                    ).show(context);
                                  }

                                  print(response.statusCode);
                                },
                                color: Colors.black,
                                textColor: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
