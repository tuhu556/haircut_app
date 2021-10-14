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
  bool _expanded = false;

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
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.color3E3E3E),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    elevation: 16,
                                    child: Container(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _selectedService.length,
                                        itemBuilder: (context, index) {
                                          return _buildRow(
                                              'assets/images/logo.png',
                                              _selectedService[index]
                                                  .serviceName
                                                  .toString(),
                                              _selectedService[index]
                                                  .price!
                                                  .toDouble());
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Show your service List'),
                          ),
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

  Widget _buildRow(String imageAsset, String name, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          Container(height: 2, color: Colors.black),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              CircleAvatar(backgroundImage: AssetImage(imageAsset)),
              SizedBox(width: 12),
              Column(
                children: [
                  Text(name),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.color3E3E3E,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    child: Text(
                      '$price',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
