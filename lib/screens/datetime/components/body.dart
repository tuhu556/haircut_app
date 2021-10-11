import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String curMonth = "";
  String curYear = "";
  String _t2 = "";
  int pressedTime = 0;

  void initState() {
    super.initState();
    curMonth = DateFormat.MMMM().format(DateTime.now());
    curYear = DateFormat.y().format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEFEEEF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                child: Text("${curMonth}, ${curYear}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18.0)),
                                margin: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                            Container(
                              child: DatePicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now(),
                                selectionColor: Colors.black,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  // New date selected
                                  setState(() {
                                    curMonth = DateFormat.MMMM().format(date);
                                    curYear = DateFormat.y().format(date);
                                    //_selectedValue = date;
                                  });
                                },
                              ),
                              margin: EdgeInsets.only(bottom: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      _timePicker(),
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
    );
  }

  Widget _timePicker() {
    final dt = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time: $_t2',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        DateTimePicker(
          type: DateTimePickerType.Time,
          timeInterval: const Duration(minutes: 30),
          is24h: true,
          startTime: DateTime(dt.year, dt.month, dt.day, 7),
          endTime: DateTime(dt.year, dt.month, dt.day, 19),
          onTimeChanged: (time) {
            setState(() {
              _t2 = DateFormat('hh:mm:ss aa').format(time);
            });
          },
        )
      ],
    );
  }
}
