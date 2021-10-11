import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/models/service.dart';
import 'package:http/http.dart' as http;

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
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _getService,
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
          ),
          selectedServices.length > 0
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: RoundedButton(
                      text: "Add (${selectedServices.length})",
                      press: () {},
                      color: AppColors.color3E3E3E,
                      textColor: Colors.white),
                ),
              )
            : Container()
        ],
      ),
    );
  }

  Widget cardService(String serviceID, String serviceName, double price,
      int durationTime, bool isSelected, int index) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      //color: Color(0xFFF3F3F4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
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
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            subtitle: Text('Price: ' +
                price.toString() +
                '\n' +
                'Duration Time: ' +
                durationTime.toString() +
                ' min'),
            isThreeLine: false,
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[700],
                  )
                : Icon(
                    Icons.check_circle_outline,
                    color: Colors.grey,
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
      )
      /**/
    );
  }
}
