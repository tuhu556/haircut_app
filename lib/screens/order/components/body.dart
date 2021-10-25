import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  List<Appointment> appointments = [];
  late Future<List<Appointment>> _getAppointment;

  Future<List<Appointment>> getAppointment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appointments.clear();
    String? token = prefs.getString("token");
    final url = Uri.parse('${Api.url}/appointment?cusEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {'Authorization': '$token'};
    var response = await http.get(
      url,
      headers: requestHeaders
    );
    var jsonData = json.decode(response.body);
    //print(jsonData);
    Appointment appointment = Appointment.formJson(jsonData);
    appointments.add(appointment);
    /* for (var e in jsonData) {
      Appointment appointment = Appointment.formJson(e);
      appointments.add(appointment);
    }  */
    /* Appointment appointment = Appointment.formJson(jsonData);
    appointments.add(appointment); */
    //appointments.add(new Appointment());
    //print(appointments.length);
    return appointments;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: _getAppointment,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(margin: EdgeInsets.only(top: size.width / 2), child: Center(child: CircularProgressIndicator()));
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error'),
                            );
                          } else
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              //physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              //primary: false,
                              itemBuilder: (BuildContext context, int i) {
                                return DetailBooking(snapshot.data[i]);
                              });
                            //return DetailBooking(snapshot.data[i]);
                        },
                      ),
                    ],
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

  Future<void> _pullRefresh() async {
    setState(() {
      _getAppointment = getAppointment();
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  Widget DetailBooking(Appointment appointment) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    final dateString = dateFormatter.format(appointment.startTime ?? DateTime.now());
    final timeString = timeFormatter.format(appointment.startTime ?? DateTime.now());
    return Container(
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
                          child: Image.asset("assets/images/logo.png", width: 60,),
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
                            Text("Barbershop", style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff4B4B4B), fontSize: 16)),
                            SizedBox(height: 5.5),
                            RichText(
                              text: TextSpan(
                                text: 'Date: ',
                                style: TextStyle(color: Color(0xff9E9E9E), fontWeight: FontWeight.bold, fontSize: 12),
                                children: [
                                  TextSpan(text: '${dateString}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.5),
                            RichText(
                              text: TextSpan(
                                text: 'Time: ',
                                style: TextStyle(color: Color(0xff9E9E9E), fontWeight: FontWeight.bold, fontSize: 12),
                                children: [
                                  TextSpan(text: '${timeString}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    appointment.status == "waiting" ? OutlinedButton(
                      onPressed: () {
                        print('Received click');
                      },
                      child: const Text('Cancel'),
                    ) : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Waiting accept", style: TextStyle(color: Color(0xff484848), fontWeight: FontWeight.w900, fontSize: 14)),
                    Text("${currencyFormatter.format(appointment.totalPrice)}", style: TextStyle(color: Color(0xffF88E79), fontWeight: FontWeight.w900, fontSize: 24))
                  ],
                )
              ],
            ),
            padding: const EdgeInsets.only(top: 10.0, right: 15, bottom: 10, left: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: Offset(0,5),
                  blurRadius: 5.0,
                  spreadRadius: 0
                )
              ],
            ),
          );
  }
}