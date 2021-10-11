import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:intl/intl.dart';

class Hours {
  int? id;
  String? time;

  Hours(this.id, this.time);
}

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String curMonth = "";
  String curYear = "";
  List<Hours> listHour = [];
  int pressedTime = 0;
  var hours = [
    {"hour": "9:00"},
    {"hour": "10:00"},
    {"hour": "11:00"},
    {"hour": "12:00"},
    {"hour": "13:00"},
    {"hour": "14:00"},
    {"hour": "15:00"},
    {"hour": "16:00"},
    {"hour": "17:00"},
    {"hour": "18:00"},
    {"hour": "19:00"},
    {"hour": "20:00"},
  ];

  void initState() {
    super.initState();
    listHour.add(new Hours(1, "9:00"));
    listHour.add(new Hours(2, "10:00"));
    listHour.add(new Hours(3, "11:00"));
    listHour.add(new Hours(4, "12:00"));
    listHour.add(new Hours(5, "13:00"));
    listHour.add(new Hours(6, "14:00"));
    listHour.add(new Hours(7, "15:00"));
    listHour.add(new Hours(8, "16:00"));
    listHour.add(new Hours(9, "17:00"));
    listHour.add(new Hours(10, "18:00"));
    listHour.add(new Hours(11, "19:00"));
    listHour.add(new Hours(12, "20:00"));
    curMonth = DateFormat.MMMM().format(DateTime.now());
    curYear = DateFormat.y().format(DateTime.now());
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
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEFEEEF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                child: Text("${curMonth}, ${curYear}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0
                                  )
                                ),
                                margin: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                            Container(
                              child: DatePicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now(),
                                selectionColor: Colors.black,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  // New date selected
                                  setState(() {
                                    curMonth = DateFormat.MMMM().format(date);
                                    curYear = DateFormat.y().format(date);
                                    //_selectedValue = date;
                                  });
                                },
                              ),
                              margin: EdgeInsets.only(bottom: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Choose time",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: 
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 14.0,  
                          mainAxisSpacing: 18.0,  
                          childAspectRatio: 2.5,
                          children: 
                            listHour.map((hour) =>
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                  primary: pressedTime == hour.id ? Colors.black : Color(0xFFEFEEEF),
                                  onPrimary: pressedTime == hour.id ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.4,
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (pressedTime == hour.id) {
                                      pressedTime = 0;
                                    } else {
                                      pressedTime = hour.id ?? 0;
                                    }
                                  });
                                },
                                child: Text(hour.time ?? "N/A"),
                              ),
                            ).toList()
                        )
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Center(
                        child: RoundedButton(
                          text: "Book",
                          press: () {
                          },
                          color: Color(0xFF151515),
                          textColor: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
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