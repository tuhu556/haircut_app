import 'package:haircut_app/models/service.dart';
import 'package:intl/intl.dart';

class Appointment {
  String? apptID;
  String? cusEmail;
  DateTime? date;
  DateTime? startTime;
  int? totalDuration;
  String? description;
  double? totalPrice;
  String? status;
  List<Service>? serives;
  List<String>? serivceID;

  Appointment({
    this.apptID,
    this.cusEmail,
    this.date,
    this.startTime,
    this.totalDuration,
    this.description,
    this.totalPrice,
    this.status,
    this.serives,
    this.serivceID,
  });

  factory Appointment.formJson(Map<String, dynamic> json) {
    List<Service>? services = [];
    for (var e in json['listService']) {
      services.add(new Service.formJson(e));
    }
    return Appointment(
      apptID: json['apptID'],
      cusEmail: json['cusEmail'],
      date: DateTime.parse(json['date']), //new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['date']), //json['date'],
      startTime: DateTime.parse(json['startTime']), //new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['startTime']),
      totalDuration: json['totalDuration'],
      description: json['description'],
      totalPrice: json['totalPrice'],
      status: json['status'],
      serives: services,
      serivceID: json['serivceID']);
  }
}
