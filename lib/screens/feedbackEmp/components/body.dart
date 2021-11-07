import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haircut_app/models/feedback.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<FeedbackCus>> _getFeedback;
  Future<List<FeedbackCus>> getFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<FeedbackCus> feedbacks = [];
    String? token = prefs.getString("token");
    final url = Uri.parse(
        '${Api.url}/getListFeedbackByEmpEmail?empEmail=${prefs.getString("email")}');
    Map<String, String> requestHeaders = {
      'Authorization': '$token',
      "Accept": "application/json; charset=UTF-8"
    };
    var response = await http.get(url, headers: requestHeaders);
    print(response.statusCode);
    var jsonData = json.decode(response.body);
    print(jsonData);
    for (var e in jsonData) {
      FeedbackCus feedback = FeedbackCus.formJson(e);
      feedbacks.add(feedback);
    }
    feedbacks.sort((a, b) {
      var aID = a.apptID;
      var bID = b.apptID;
      return bID!.compareTo(aID!);
    });
    print("le: " + feedbacks.length.toString());
    return feedbacks;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _getFeedback = getFeedback();
    });
  }

  @override
  void initState() {
    super.initState();
    _getFeedback = getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                      "Your Feedback",
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
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: Container(
                    child: FutureBuilder(
                      future: _getFeedback,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text("You haven't any feedback yet!"),
                          );
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
                                return Card(snapshot.data[i]);
                              });
                      },
                    ),
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

  Widget Card(FeedbackCus feedback) {
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
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 30,
                        itemCount: 5,
                        initialRating: feedback.rating!,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                          }
                          return Container();
                        },
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(height: 5.5),
                      Text(
                        "ID : " + feedback.apptID.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xff4B4B4B),
                            fontSize: 16),
                      ),
                      SizedBox(height: 5.5),
                      Text(
                        "Comment: " + feedback.comment.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xff4B4B4B),
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
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
    );
  }
}
