class Customer {
  final String cusEmail;
  final String cusName;
  final String password;
  final String phone;
  final String status;
  final String verifiCode;
  final String token;
  Customer(
      {required this.cusEmail,
      required this.cusName,
      required this.password,
      required this.phone,
      required this.status,
      required this.verifiCode,
      required this.token});

  factory Customer.formJson(Map<String, dynamic> json) {
    return Customer(
        cusEmail: json['cusEmail'],
        cusName: json['cusName'],
        password: json['password'],
        phone: json['phone'],
        status: json['status'],
        verifiCode: json['verifyCode'],
        token: json['token']);
  }

  Map<String, dynamic> toJson() => {
        "cusEmail": cusEmail,
        "cusName": cusName,
        "password": password,
        "phone": phone,
        "status": status,
        "verifiCode": verifiCode,
      };
}
