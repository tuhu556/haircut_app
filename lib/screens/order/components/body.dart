import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/models/feedback.dart' as feedbackModel;
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
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);

    for (var e in jsonData) {
      Appointment appointment = Appointment.formJson(e);
      final urlFeedback = Uri.parse('${Api.url}/feedbackApptID?apptID=${appointment.apptID}');
      var responseFeedback = await http.get(urlFeedback, headers: requestHeaders);
      if (responseFeedback.body.isNotEmpty) {
        appointment.feedback = feedbackModel.Feedback.formJson(json.decode(responseFeedback.body));
      }
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
                        print(snapshot.error);
                        return Center(
                          child: Text('Error'),
                        );
                      } else
                        return ListView.builder(
                            //shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            //primary: false,
                            itemBuilder: (BuildContext context, int i) {
                              return DetailBooking(snapshot.data[i]);
                            });
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
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    String statusText = listStatus[0] as String;
    int statusColor = listStatus[1] as int;
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Detail Booking",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            margin: const EdgeInsets.only(left: 20),
                          ),
                          Container(
                            child: Text(
                              "${statusText}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(statusColor)),
                            ),
                            margin: const EdgeInsets.only(left: 20),
                          ),
                        ],
                      ),
                      appointment.status == "ON PROCESS" ||
                              appointment.status == "ACCEPT"
                          ? Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: OutlinedButton(
                                onPressed: () {
                                  cancelAppointment(appointment.apptID ?? "");
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 2.5),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/images/deadline.png",
                            width: 30,
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xffCFF4FF),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Appointment ID: ',
                                style: TextStyle(
                                    color: Color(0xff9E9E9E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                children: [
                                  TextSpan(
                                      text: '${appointment.apptID}',
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
                            RichText(
                              text: TextSpan(
                                text: "Total Duration Time: ",
                                style: TextStyle(
                                    color: Color(0xff9E9E9E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                children: [
                                  TextSpan(
                                      text:
                                          "${appointment.totalDuration} minutes",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            appointment.description != ""
                                ? SizedBox(height: 2.5)
                                : Container(),
                            appointment.description != ""
                                ? RichText(
                                    text: TextSpan(
                                      text: "Description: ",
                                      style: TextStyle(
                                          color: Color(0xff9E9E9E),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      children: [
                                        TextSpan(
                                            text: "${appointment.description}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 2.5),
                            RichText(
                              text: TextSpan(
                                text: "Total Price: ",
                                style: TextStyle(
                                    color: Color(0xff9E9E9E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                children: [
                                  TextSpan(
                                      text:
                                          "${currencyFormatter.format(appointment.totalPrice)}",
                                      style: TextStyle(
                                          color: Color(0xFF66ADFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              Text(
                                  "${currencyFormatter.format(appointment.serives?[i].price)}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))
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
                        Text("ID : " + appointment.apptID.toString(),
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
                appointment.status == "ON PROCESS" ||
                        appointment.status == "ACCEPT"
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
