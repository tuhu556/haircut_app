class Customer {
  final String id;
  final String cusEmail;
  final String password;
  final String phone;
  final bool status;
  final String verifiCode;
  Customer(
      {required this.id,
      required this.cusEmail,
      required this.password,
      required this.phone,
      required this.status,
      required this.verifiCode});
}
