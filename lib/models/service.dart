import 'dart:convert';

Service serviceJson(String str) => Service.formJson(json.decode(str));
//String ServiceToJson(Service data) => json.encode(data.toJson());

class Service {
  String? id;
  String? serviceID;
  String? serviceName;
  double? price;
  bool? status;
  int? durationTime;

  Service(
      {this.id,
      this.serviceID,
      this.serviceName,
      this.price,
      this.durationTime,
      this.status});

  factory Service.formJson(Map<String, dynamic> json) {
    return Service(
        id: json['id'],
        serviceID: json['serviceID'],
        serviceName: json['serviceName'],
        price: json['price'],
        durationTime: json['durationTime'],
        status: json['status']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceID": serviceID,
        "serviceName": serviceName,
        "price": price,
        "durationTime": durationTime,
        "status": status,
      };
}
