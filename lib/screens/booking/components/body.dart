import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haircut_app/models/service.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loadServices = true;
  Future<List<Service>> getServices() async {
    var response = await http
        .get(Uri.parse('https://haircut-fall-2021.herokuapp.com/api/services'));
    var jsonData = json.decode(response.body);
    List<Service> services = [];

    for (var e in jsonData) {
      Service service = new Service();
      service.id = e["id"];
      service.serviceID = e["serviceID"];
      service.serviceName = e["serviceName"];
      service.price = e["price"];
      service.durationTime = e["durationTime"];
      service.status = e["status"];
      services.add(service);
      print(service.serviceName);
    }
    
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getServices(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int i) {
                      return cardService(
                        snapshot.data[i].serviceName,
                        snapshot.data[i].price,
                        snapshot.data[i].durationTime,
                        false);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cardService(
    String serviceName, double price, int durationTime, bool isSelected) {
  return ListTile(
    title: Text(
      serviceName,
      style: TextStyle(fontWeight: FontWeight.w700),
    ),
    subtitle: Text('Price: ' +
        price.toString() +
        ' - ' +
        'Duration Time: ' +
        durationTime.toString() +
        ' min'),
    isThreeLine: true,
    trailing: isSelected
        ? Icon(
            Icons.check_circle,
            color: Colors.green[700],
          )
        : Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
          ),
  );
}
