import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';
import 'package:haircut_app/models/appointment.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:haircut_app/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haircut_app/screens/order/components/body.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<MyNotification>> _getNotification;

  Future<List<MyNotification>> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    List<MyNotification> notifications = [];
    final url = Uri.parse(
        '${Api.url}/getNotiByCusEmail?cusEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);

    for (var e in jsonData) {
      
      MyNotification notification = MyNotification.formJson(e);
      notifications.add(notification);
    }
    /* notification.sort((a, b) {
      var adate = a.createDate ?? DateTime.now();
      var bdate = b.createDate ?? DateTime.now();
      return bdate.compareTo(adate);
    }); */
    final notificationModel = Provider.of<BadgeNotification>(context, listen: false);
    notificationModel.setNumber(notifications.length);
    return notifications;
  }

  _updateNotificationStatus(MyNotification notification, String? token) async {
    final url = Uri.parse('${Api.url}/updateNotiIsReadStatus');
    Map<String, String> requestHeaders = {'Authorization': '$token'};
    final Map<String, dynamic> body = {
      "notiID": notification.notiID,
    };
    var _ = await http.put(url, headers: requestHeaders, body: body);
    _pullRefresh();
    /* print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      
    } */
  }

  _clickNotification(MyNotification notification) async {
    Helpers.shared.showDialogProgress(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final url = Uri.parse(
        '${Api.url}/appointmentApptID?apptID=${notification.apptID}');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    Appointment appointment = Appointment.formJson(jsonData);
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final dateString =
        dateFormatter.format(appointment.startTime ?? DateTime.now());
    final timeString =
        timeFormatter.format(appointment.startTime ?? DateTime.now());
    Helpers.shared.hideDialogProgress(context);
    _updateNotificationStatus(notification, token);
    showSheet(context, appointment, dateString, timeString);
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _getNotification = getNotification();
    });
  }

  @override
  void initState() {
    _getNotification = getNotification();
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
                      "Notification",
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
                    future: _getNotification,
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
                              return DetailNotification(snapshot.data[i]);
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

  Widget DetailNotification(MyNotification notification) {
    String content = "";
    int color = 0xff000000;
    switch(notification.newStatus) {
      case "ACCEPT":
        content = "accepted";
        color = 0xff5cff92;
        break;
      case "DENY":
        content = "rejected";
        color = 0xffff5e5e;
        break;
    }
    return GestureDetector(
      onTap: () {
        _clickNotification(notification);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Icon(Icons.notifications, color: Color(0xFFF8F8F8),),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(right: 30.0, bottom: 1.0),
              decoration: BoxDecoration(
                color: Color(0xFF00AEFF),
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
                    text: 'Your appointment has been ',
                    style: TextStyle(color: Color(0xFF525252)),
                    children: [
                      TextSpan(
                        text: '${content}',
                        style: TextStyle(color: Color(color), fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                RichText(
                  text: TextSpan(
                    text: 'Appointment ID: ',
                    style: TextStyle(color: Color(0xFF525252)),
                    children: [
                      TextSpan(
                        text: '${notification.apptID}',
                        style: TextStyle(color: Color(0xFF4D4D4D), fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        padding: const EdgeInsets.only(top: 35.0, right: 15, bottom: 35, left: 15),
        //margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.5)),
            ),
            color: Colors.white,
        ),
      ),
    );
  }
}

class Helpers {
  Helpers._();
  static final Helpers shared = Helpers._();

  bool _isDialogLoading = false;

  void showDialogProgress(BuildContext context) {
    if (!_isDialogLoading) {
      _isDialogLoading = true;
      showDialog(
        //prevent outside touch
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //prevent Back button press
          return WillPopScope(
            onWillPop: () {
              return Future<bool>.value(false);
            },
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void hideDialogProgress(BuildContext context) {
    if (_isDialogLoading) {
      _isDialogLoading = false;
      Navigator.pop(context);
    }
  }
}