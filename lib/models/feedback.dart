class FeedbackCus {
  String? feedbackID;
  String? cusEmail;
  String? apptID;
  double? rating;
  String? comment;

  FeedbackCus({
    this.feedbackID,
    this.cusEmail,
    this.apptID,
    this.rating,
    this.comment,
  });

  factory FeedbackCus.formJson(Map<String, dynamic> json) {
    return FeedbackCus(
        feedbackID: json['feedbackID'],
        cusEmail: json['cusEmail'],
        apptID: json['apptID'],
        rating: json['rating'],
        comment: json['comment']);
  }
}
