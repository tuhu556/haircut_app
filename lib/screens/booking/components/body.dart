import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/screens/datetime/datetime_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Service> selectedServices = [];
  List<Service> services = [];
  late Future<List<Service>> _getService;

  Future<List<Service>> getServices() async {
    var response = await http
        .get(Uri.parse('https://hair-cut.herokuapp.com/api/availableServices'));
    var jsonData = json.decode(response.body);

    for (var e in jsonData) {
      Service service = new Service();
      service.id = e["id"];
      service.serviceID = e["serviceID"];
      service.serviceName = e["serviceName"];
      service.price = e["price"];
      service.durationTime = e["durationTime"];
      service.status = e["status"];
      services.add(service);
    }

    return services;
  }

  @override
  void initState() {
    _getService = getServices();
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
                      "Services",
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
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: FutureBuilder(
                      future: _getService,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error'),
                          );
                        } else
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int i) {
                                return cardService(
                                    snapshot.data[i].serviceID,
                                    snapshot.data[i].serviceName,
                                    snapshot.data[i].price,
                                    snapshot.data[i].durationTime,
                                    snapshot.data[i].isSelected,
                                    i);
                              });
                      },
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: selectedServices.length > 0
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: RoundedButton(
                                text: "Service (${selectedServices.length})",
                                press: () {
                                  Navigator.pushNamed(
                                      context, DatetimeScreen.routeName,
                                      arguments: selectedServices);
                                },
                                color: Colors.black,
                                textColor: Colors.white),
                          )
                        : null,
                  ),
                ],
              ),
            ),

            /* selectedServices.length > 0 ? Center(
              child: Container(
                color: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 5),
                child: RoundedButton(
                  text: "Book (${selectedServices.length})",
                  press: () {

                  },
                  color: Colors.white,
                  textColor: Colors.white
                ),
              ),
            ) : Container() */
          ],
        ),
      ),
    );
  }

  Widget cardService(String serviceID, String serviceName, double price,
      int durationTime, bool isSelected, int index) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      //color: Color(0xFFF3F3F4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Image.asset("assets/images/logo.png"),
            title: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                serviceName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Duration Time ${durationTime.toString()} min"),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      "${currencyFormatter.format(price)}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4063c0)),
                    ))
              ],
            ),
            isThreeLine: false,
            trailing: Container(
              child: isSelected
                  ? Icon(Icons.check_circle, color: Colors.green[700])
                  : Icon(Icons.check_circle_outline, color: Colors.grey),
              margin: EdgeInsets.only(top: 19),
            ),
            onTap: () {
              setState(() {
                services[index].isSelected = !services[index].isSelected;
                if (services[index].isSelected == true) {
                  selectedServices.add(services[index]);
                } else if (services[index].isSelected == false) {
                  selectedServices.removeWhere(
                    (element) => element.serviceID == services[index].serviceID,
                  );
                }
              });
            },
          )
        ],
      ),
    );
  }
}
