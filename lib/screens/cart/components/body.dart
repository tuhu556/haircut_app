import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/models/service.dart';
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    email = widget.appointment.cusEmail;
    bookingDate = widget.appointment.date;
    startTime = widget.appointment.startTime;
    totalDuration = widget.appointment.totalDuration;
    totalPrice = widget.appointment.totalPrice;
    _selectedServices = widget.appointment.serives;
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
                      // ListView.builder(
                      //   itemCount: _selectedServices!.length,
                      //   itemBuilder: (context, index) {
                      //     return Row(
                      //       children: [
                      //         Text(
                      //           _selectedServices![index]
                      //               .serviceName
                      //               .toString(),
                      //           style: TextStyle(
                      //               fontSize: 15, fontWeight: FontWeight.w500),
                      //         ),
                      //         // Spacer(),
                      //         // Text(
                      //         //   _selectedServices![index]
                      //         //       .serviceName
                      //         //       .toString(),
                      //         //   style: TextStyle(
                      //         //       fontSize: 15, fontWeight: FontWeight.w500),
                      //         // ),
                      //       ],
                      //     );
                      //   },
                      // ),

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
                        height: size.height * 0.1,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: RoundedButton(
                              text: "Service ",
                              press: () {
                                // Navigator.pushNamed(
                                //     context, DatetimeScreen.routeName,
                                //     arguments: selectedServices);
                              },
                              color: Colors.black,
                              textColor: Colors.white),
                        ),
                      ),
                    ],
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
