import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/screens/booking/booking_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<Service>> _getService;
  Future<List<Service>> getService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    List<Service> services = [];
    final url = Uri.parse('${Api.url}/getSuggestedServices');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    for (var e in jsonData) {
      Service service = Service.formJson(e);
      services.add(service);
    }
    services.sort((a, b) {
      var aCount = a.count;
      var bCount = b.count;
      return aCount!.compareTo(bCount!);
    });
    return services;
  }

  void getCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  late FirebaseMessaging messaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _getService = getService();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: Text("Notification"),
            content: Text("$payload"),
          );
        },
      );
    });
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("all");
    messaging.getToken().then((token) {
      assert(token != null);
      print('Token FCM : $token');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      _showNotificationWithDefaultSound(event.notification!.body ?? "");
      /* showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }); */
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  Future _showNotificationWithDefaultSound(String content) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "app_icon");
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Hello!',
      content,
      platformChannelSpecifics,
      payload: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getCustomer();
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
                      "Home",
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
                    children: [
                      Center(
                        child: GestureDetector(
                          child: Image(
                            image: AssetImage("assets/images/Book.png"),
                          ),
                          onTap: () {
                            //_showNotificationWithDefaultSound();
                            Navigator.pushNamed(
                              context,
                              BookingScreen.routeName,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Most farvorite services",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        child: FutureBuilder(
                          future: _getService,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (!snapshot.hasData) {
                              return Center(
                                child: Text("Emty"),
                              );
                            }
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                child: Text('Error'),
                              );
                            } else
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Card(snapshot.data[i]);
                                },
                              );
                          },
                        ),
                      )
                      ///////////////////
                    ],
                  ),
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
            )
          ],
        ),
      ),
    );
  }

  Widget Card(Service service) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');

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
                    child: Image.asset(
                      "assets/images/keoluoc.png",
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
                      Text(
                        service.serviceName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.color999999,
                            fontSize: 16),
                      ),
                      SizedBox(height: 5.5),
                      RichText(
                        text: TextSpan(
                          text: 'Price: ',
                          style: TextStyle(
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: [
                            TextSpan(
                                text:
                                    "${currencyFormatter.format(service.price)}",
                                style: TextStyle(
                                    color: AppColors.colorGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      padding:
          const EdgeInsets.only(top: 10.0, right: 10, bottom: 10, left: 10),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
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
    );
  }
}
