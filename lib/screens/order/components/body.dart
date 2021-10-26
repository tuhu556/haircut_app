import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<Appointment>> _getAppointment;

  Future<List<Appointment>> getAppointment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Appointment> appointments = [];
    String? token = prefs.getString("token");
    final url = Uri.parse(
        '${Api.url}/appointmentCusEmail?cusEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {'Authorization': '$token'};
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);

    for (var e in jsonData) {
      Appointment appointment = Appointment.formJson(e);
      appointments.add(appointment);
    }
    appointments.sort((a, b) {
      var adate = a.startTime ?? DateTime.now();
      var bdate = b.startTime ?? DateTime.now();
      return bdate.compareTo(adate);
    });
    return appointments;
  }

  void cancelAppointment(String apptID) async {
    print("cancel");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final url = Uri.parse('${Api.url}/updateAppointmentStatus');
    Map<String, String> requestHeaders = {'Authorization': '$token'};
    final Map<String, dynamic> body = {
      "apptID": apptID,
      "status": "CANCEL BY CUSTOMER",
    };
    var response = await http.put(url, headers: requestHeaders, body: body);
    if (response.statusCode == 200) {
      _pullRefresh();
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _getAppointment = getAppointment();
    });
  }

  @override
  void initState() {
    super.initState();
    _getAppointment = getAppointment();
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
                      "My Bookings",
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
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Container(
                  child: FutureBuilder(
                    future: _getAppointment,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error'),
                        );
                      } else
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            //physics: NeverScrollableScrollPhysics(),
                            //primary: false,
                            itemBuilder: (BuildContext context, int i) {
                              return DetailBooking(snapshot.data[i]);
                            });
                      //return DetailBooking(snapshot.data[i]);
                    },
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSheet(
      Appointment appointment, String dateString, String timeString) {
    List<dynamic> listStatus = getTextStatus(appointment.status ?? "");
    String statusText = listStatus[0] as String;
    int statusColor = listStatus[1] as int;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                      child: Text(
                    "Detail Booking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 2.5),
                  RichText(
                    text: TextSpan(
                      text: 'Date: ',
                      style: TextStyle(
                          color: Color(0xff9E9E9E),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      children: [
                        TextSpan(
                            text: '${dateString}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5),
                  RichText(
                    text: TextSpan(
                      text: 'Time: ',
                      style: TextStyle(
                          color: Color(0xff9E9E9E),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      children: [
                        TextSpan(
                            text: '${timeString}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: appointment.serives?.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          child:
                              Text(appointment.serives?[i].serviceName ?? ""),
                        );
                      },
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
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

  List<dynamic> getTextStatus(String status) {
    String statusText = "";
    int statusColor = 0xff242424;
    if (status == "ON PROCESS") {
      statusText = "Waiting accept";
      statusColor = 0xff5cff92;
    } else if (status == "ACCEPT") {
      statusText = "Accepted";
    } else if (status == "CANCEL BY ADMIN") {
      statusText = "Rejected";
      statusColor = 0xffff5e5e;
    } else if (status == "CANCEL BY CUSTOMER") {
      statusText = "Cancel";
      statusColor = 0xffff5e5e;
    } else if (status == "DONE") {
      statusText = "Done";
      statusColor = 0xffff5e5e;
    }
    return [statusText, statusColor];
  }

  Widget DetailBooking(Appointment appointment) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    final dateString =
        dateFormatter.format(appointment.startTime ?? DateTime.now());
    final timeString =
        timeFormatter.format(appointment.startTime ?? DateTime.now());
    List<dynamic> listStatus = getTextStatus(appointment.status ?? "");
    String statusText = listStatus[0] as String;
    int statusColor = listStatus[1] as int;
    return GestureDetector(
      onTap: () {
        _showSheet(appointment, dateString, timeString);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 60,
                      ),
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(right: 10.0, bottom: 1.0),
                      decoration: BoxDecoration(
                        color: Color(0xffFFDFF2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AppointmentID",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xff4B4B4B),
                                fontSize: 16)),
                        SizedBox(height: 5.5),
                        RichText(
                          text: TextSpan(
                            text: 'Date: ',
                            style: TextStyle(
                                color: Color(0xff9E9E9E),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text: '${dateString}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.5),
                        RichText(
                          text: TextSpan(
                            text: 'Time: ',
                            style: TextStyle(
                                color: Color(0xff9E9E9E),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text: '${timeString}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                appointment.status == "ON PROCESS"
                    ? OutlinedButton(
                        onPressed: () {
                          cancelAppointment(appointment.apptID ?? "");
                        },
                        child: const Text('Cancel'),
                      )
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${statusText}",
                    style: TextStyle(
                        color: Color(statusColor),
                        fontWeight: FontWeight.w900,
                        fontSize: 14)),
                Text("${currencyFormatter.format(appointment.totalPrice)}",
                    style: TextStyle(
                        color: Color(0xffF88E79),
                        fontWeight: FontWeight.w900,
                        fontSize: 24))
              ],
            )
          ],
        ),
        padding:
            const EdgeInsets.only(top: 10.0, right: 15, bottom: 10, left: 15),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(0, 5),
                blurRadius: 5.0,
                spreadRadius: 0)
          ],
        ),
      ),
    );
  }
}
