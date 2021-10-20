import 'package:haircut_app/models/service.dart';

class Appointment {
  String? bookingID;
  String? cusEmail;
  DateTime? bookingDate;
  DateTime? startTime;
  int? totalDuration;
  String? note;
  double? totalPrice;
  bool? status;
  List<Service>? serives;

  Appointment({
    this.bookingID,
    this.cusEmail,
    this.bookingDate,
    this.startTime,
    this.totalDuration,
    this.note,
    this.totalPrice,
    this.status,
    this.serives,
  });
}
