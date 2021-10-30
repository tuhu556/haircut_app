class MyNotification {
  final String notiID;
  final String currentStatus;
  final String newStatus;
  final String cusEmail;
  final String apptID;
  final bool read;

  MyNotification({
    required this.notiID,
    required this.currentStatus,
    required this.newStatus,
    required this.cusEmail,
    required this.apptID,
    required this.read,
  });

  factory MyNotification.formJson(Map<String, dynamic> json) {
    return MyNotification(
      notiID: json['notiID'],
      currentStatus: json['currentStatus'],
      newStatus: json['newStatus'],
      cusEmail: json['cusEmail'],
      apptID: json['apptID'],
      read: json['read'] == 'true');
  }
}
