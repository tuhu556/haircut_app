import 'dart:convert';
import 'package:haircut_app/models/service.dart';
import 'package:http/http.dart' as http;

class ServiceApi {
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
}
