class Feedback {
  final String feedbackID;
  final String cusEmail;
  final String apptID;
  final double rating;
  final String commnent;

  Feedback({
    required this.feedbackID,
    required this.cusEmail,
    required this.apptID,
    required this.rating,
    required this.commnent,
  });

  factory Feedback.formJson(Map<String, dynamic> json) {
    return Feedback(
      feedbackID: json['feedbackID'],
      cusEmail: json['cusEmail'],
      apptID: json['apptID'],
      rating: json['rating'],
      commnent: json['commnent']);
  }
}
