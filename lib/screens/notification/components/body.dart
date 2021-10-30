import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:haircut_app/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    return notifications;
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
    return Container(
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
              Text("${notification.newStatus}")
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
    );
  }
}
