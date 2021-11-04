import 'dart:convert';
import 'dart:math';

import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List <int> randomColor = [
    0xffd0f1ff,
    0xfffee8d0,
    0xffecddfc,
    0xffffddda,
  ];

  late Future<List<Appointment>> _getAppointment;
  DateTime selectedDate = DateTime.now();
  

  Future<List<Appointment>> getAppointment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Appointment> appointments = [];
    String? token = prefs.getString("token");
    final url = Uri.parse(
        '${Api.url}/appointmentEmpEmail?empEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    
    
    var jsonData = json.decode(response.body);
    DateTime d1 = DateTime.utc(selectedDate.year,selectedDate.month,selectedDate.day);
    for (var e in jsonData) {
      Appointment appointment = Appointment.formJson(e);
      //print("${appointment.apptID}: (${appointment.date}) (${selectedDate}) | ${d1.difference(appointment.date ?? DateTime.now()).inDays}");
      if (d1.difference(appointment.date ?? DateTime.now()).inDays == 0) {
        appointments.add(appointment);
      }
    }
    appointments.sort((a, b) {
      var adate = a.startTime ?? DateTime.now();
      var bdate = b.startTime ?? DateTime.now();
      return adate.compareTo(bdate);
    });
    return appointments;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _getAppointment = getAppointment();
    });
  }

  @override
  void initState() {
    _getAppointment = getAppointment();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
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
                      "Schedule",
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: Container(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _dateTimePicker(),
                              Container(
                                margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                child: Text(
                                  "Tasks",
                                  style: TextStyle(color: Colors.black38, fontSize: 25, fontWeight: FontWeight.w700),
                                ),
                              ),
                              FutureBuilder(
                                future: _getAppointment,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                      child: Text("You haven't any booking yet!"),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return Center(
                                      child: Text('Error'),
                                    );
                                  } else {
                                    if (snapshot.data?.length == 0) {
                                      return Container(
                                        child: Center(
                                          child: Text("You don't have any task in this date!"),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: DetailAppoinment(snapshot.data[i])
                                        );
                                      }
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
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
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  int _previousColor = 0;

  Widget DetailAppoinment(Appointment appointment) {
    final timeFormatter = DateFormat('HH:mm a');
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    final timeString = timeFormatter.format(appointment.startTime ?? DateTime.now());
    
    int _randomColor = randomColor[Random().nextInt(randomColor.length)];
    while(_randomColor == _previousColor) {
      _randomColor = randomColor[Random().nextInt(randomColor.length)];
      _previousColor = _randomColor;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                //margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("${timeString}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),)
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'ID: ',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: [
                          TextSpan(
                              text: '${appointment.apptID}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(height: 3,),
                    RichText(
                      text: TextSpan(
                        text: 'Name: ',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: [
                          TextSpan(
                              text: '${appointment.cusEmail}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(height: 3,),
                    RichText(
                      text: TextSpan(
                        text: 'Duration Time: ',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: [
                          TextSpan(
                              text: '${appointment.totalDuration} minutes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(height: 3,),
                    RichText(
                      text: TextSpan(
                        text: 'Price: ',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: [
                          TextSpan(
                              text: '${currencyFormatter.format(appointment.totalPrice)}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(height: 3,),
                    appointment.description != null ? RichText(
                      text: TextSpan(
                        text: 'Description: ',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: [
                          TextSpan(
                              text: '${appointment.description}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ) : Container(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.8),
                        onPrimary: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        minimumSize: Size(100, 30), //////// HERE
                      ),
                      onPressed: () {
                        _showSheet(appointment);
                      },
                      child: Text('Services'),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  color: Color(_randomColor),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            )
          ],
        ),
        _dashedText(),
      ],
    );
  }

  void _showSheet(Appointment appointment) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          //initialChildSize: 0.4,
          expand: false,
          builder: (_, controller) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Services",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    margin: const EdgeInsets.only(top: 20, left: 20),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: appointment.serives?.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      "assets/images/keoluoc.png",
                                      width: 30,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF2F5FF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${appointment.serives?[i].serviceName}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3.5),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Duration Time: ',
                                          style: TextStyle(
                                              color: Color(0xFF999999),
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${appointment.serives?[i].durationTime} minutes",
                                                style: TextStyle(
                                                    color: Color(0xFF999999),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text("${currencyFormatter.format(appointment.serives?[i].price)}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  Widget _dateTimePicker() {
    final dt = DateTime.now();
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateTimePicker(
            type: DateTimePickerType.Date,
            initialSelectedDate: DateTime.now(),
            startDate: dt.subtract(const Duration(days: 0)),
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
                selectedDate = DateTime.utc(date.year,date.month,date.day);
                _getAppointment = getAppointment();
               /*  _d1 = DateFormat('dd MMM, yyyy').format(date);
                bookingDate = date; */
              });
            },
            /* onTimeChanged: (time) {
              setState(() {
                _t1 = DateFormat('H:mm').format(time);
                startTime = time;
              });
            }, */
          ),
          const SizedBox(height: 10,),
          Center(
            child: Text(
              'You are viewing: ${dateFormatter.format(selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 16.0),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );
  }
}