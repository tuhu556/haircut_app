import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/screens/booking/booking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void getCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    /* Firebase.initializeApp().whenComplete(() { 
      setState(() {});
    }); */
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((token){
      assert(token != null);
      print('Token FCM : $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        print("message recieved");
        print(event.notification!.body);
        showDialog(
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
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
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
              padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 7.0),
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
                      Table(
                        children: [
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset("assets/images/Haircut.png"),
                              ),
                              GestureDetector(
                                child:
                                    Image.asset("assets/images/HairDying.png"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                    "assets/images/HairCurling.png"),
                              ),
                              GestureDetector(
                                child:
                                    Image.asset("assets/images/HairCare.png"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              GestureDetector(
                                child: Image.asset("assets/images/Combo1.png"),
                              ),
                              GestureDetector(
                                child: Image.asset("assets/images/Combo2.png"),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
