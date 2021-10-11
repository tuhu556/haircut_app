import 'dart:convert';

import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/repository/service/repository.dart';
import 'package:http/http.dart' as http;

class ServiceRepository implements Repository {
  String dataUrl = 'https://hair-cut.herokuapp.com/api';
  @override
  Future<List<Service>> getService() async {
    List<Service> serviceList = [];
    var url = Uri.parse('$dataUrl/availableServices');
    var response = await http.get(url);
    var body = json.decode(response.body);
    for (var e in body) {
      //serviceList.add(Service.formJson(body[e]));
      Service service = new Service();
      service.id = e["id"];
      service.serviceID = e["serviceID"];
      service.serviceName = e["serviceName"];
      service.price = e["price"];
      service.durationTime = e["durationTime"];
      service.status = e["status"];
      serviceList.add(service);
    }

    return serviceList;
  }
}
