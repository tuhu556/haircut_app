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
  bool isSelected;
  int? count;

  Service(
      {this.id,
      this.serviceID,
      this.serviceName,
      this.price,
      this.durationTime,
      this.status,
      this.isSelected = false,
      this.count});

  factory Service.formJson(Map<String, dynamic> json) {
    return Service(
        id: json['id'],
        serviceID: json['serviceID'],
        serviceName: json['serviceName'],
        price: json['price'],
        durationTime: json['durationTime'],
        status: json['status'],
        count: json['count']);
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
