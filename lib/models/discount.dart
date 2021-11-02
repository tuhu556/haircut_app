class Discount {
  String? discountCode;
  String? discountName;
  String? endDate;
  String? startDate;
  bool? status;
  double? value;

  Discount(
      {this.discountCode,
      this.discountName,
      this.endDate,
      this.startDate,
      this.status,
      this.value});

  Discount.fromJson(Map<String, dynamic> json) {
    discountCode = json['discountCode'];
    discountName = json['discountName'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    status = json['status'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountCode'] = this.discountCode;
    data['discountName'] = this.discountName;
    data['endDate'] = this.endDate;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    data['value'] = this.value;
    return data;
  }
}
