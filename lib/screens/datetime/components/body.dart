import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/service.dart';
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
  DateTime? bookingDate;
  DateTime? startDate;
  double? totalPrice;

  List<Service> _selectedService = [];
  int pressedTime = 0;
  void initState() {
    super.initState();
    curMonth = DateFormat.MMMM().format(DateTime.now());
    curYear = DateFormat.y().format(DateTime.now());
    didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args != null) {
      _selectedService = args["services"];
      print(_selectedService);
      for (Service i in _selectedService) {
        print(i.serviceName);
      }
    }
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
                        Container(
                          child: _dateTimePicker(),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Center(
                          child: RoundedButton(
                              text: "Your Services",
                              press: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('AlertDialog Title'),
                                      // content: ListView.builder(
                                      //   itemCount: _selectedService.length,
                                      //   itemBuilder:
                                      //       (BuildContext context, int i) {
                                      //         return ListView (_selectedService[i].serviceName);
                                      //   },
                                      // ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                              color: Color(0xFF151515),
                              textColor: Colors.white),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Center(
                          child: RoundedButton(
                              text: "Book",
                              press: () {},
                              color: Color(0xFF151515),
                              textColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
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
              _t1 = DateFormat('H:mm').format(time);
            });
          },
        )
      ],
    );
  }

  Widget cardService(String? serviceID, String? serviceName, double? price,
      int? durationTime) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 20,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: Image.asset("assets/images/logo.png"),
              // title: Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: Text(
              //     serviceName,
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              //   ),
              // ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duration Time ${durationTime.toString()} min"),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "${currencyFormatter.format(price)}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4063c0)),
                      ))
                ],
              ),
              isThreeLine: false,
            )
          ],
        )
        /**/
        );
  }
}
