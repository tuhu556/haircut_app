import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String curMonth = "";
  String curYear = "";
  String _d1 = "";
  String _t1 = "";
  int pressedTime = 0;
  DateTime selectedDate = DateTime.now();
  void initState() {
    super.initState();
    curMonth = DateFormat.MMMM().format(DateTime.now());
    curYear = DateFormat.y().format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      child: SafeArea(
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
                        "Date & Time",
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFEFEEEF),
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(25.0),
                        //       topRight: Radius.circular(25.0),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Center(
                        //         child: Container(
                        //           child: Text("${curMonth}, ${curYear}",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w800,
                        //                   fontSize: 18.0)),
                        //           margin: EdgeInsets.symmetric(vertical: 15),
                        //         ),
                        //       ),
                        //       Container(
                        //         child: DatePicker(
                        //           DateTime.now(),
                        //           initialSelectedDate: DateTime.now(),
                        //           selectionColor: Colors.black,
                        //           selectedTextColor: Colors.white,
                        //           onDateChange: (date) {
                        //             // New date selected
                        //             setState(() {
                        //               curMonth = DateFormat.MMMM().format(date);
                        //               curYear = DateFormat.y().format(date);
                        //               selectedDate = date;
                        //               //_selectedValue = date;
                        //             });
                        //           },
                        //         ),
                        //         margin: EdgeInsets.only(bottom: 15),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        //_timePicker(),
                        Container(child: _dateTimePicker(), padding: EdgeInsets.symmetric(horizontal: 5),),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Center(
                          child: RoundedButton(
                              text: "Book",
                              press: () {},
                              color: Color(0xFF151515),
                              textColor: Colors.white),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
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

  Widget _timePicker() {
    final dt = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time: $_t1',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0)
        ),
        DateTimePicker(
          initialSelectedDate: dt,
          startDate: dt.subtract(const Duration(days: 1)),
          type: DateTimePickerType.Time,
          timeInterval: const Duration(minutes: 30),
          is24h: true,
          startTime: DateTime(dt.year, dt.month, dt.day, 7),
          endTime: DateTime(dt.year, dt.month, dt.day, 19),
          onDateChanged: (date) {
            setState(() {
              _d1 = DateFormat('dd MMM, yyyy').format(date);
            });
          },
          onTimeChanged: (time) {
            setState(() {
              _t1 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        )
      ],
    );
  }

  Widget _dateTimePicker() {
    final dt = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /* Text(
          'Date & Time Picker',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8), */
        Text(
          'Booking Date: $_d1\nTime: $_t1',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0),
        ),
        const SizedBox(height: 16),
        DateTimePicker(
          initialSelectedDate: dt,
          startDate: dt.subtract(const Duration(days: 1)),
          endDate: dt.add(const Duration(days: 60)),
          startTime: DateTime(dt.year, dt.month, dt.day, 7),
          endTime: DateTime(dt.year, dt.month, dt.day, 18),
          timeInterval: const Duration(minutes: 30),
          datePickerTitle: 'Pick your date',
          timePickerTitle: 'Pick your time',
          timeOutOfRangeError: 'Sorry shop is closed now',
          is24h: true,
          numberOfWeeksToDisplay: 1,
          onDateChanged: (date) {
            setState(() {
              _d1 = DateFormat('dd MMM, yyyy').format(date);
            });
          },
          onTimeChanged: (time) {
            setState(() {
              _t1 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        )
      ],
    );
  }
}
