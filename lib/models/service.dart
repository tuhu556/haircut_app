import 'dart:ffi';

class Service {
  final String id;
  final String serviceID;
  final String serviceName;
  final double price;
  final bool status;
  final int durationTime;

  Service(
      {required this.id,
      required this.serviceID,
      required this.serviceName,
      required this.price,
      required this.durationTime,
      required this.status});
}
