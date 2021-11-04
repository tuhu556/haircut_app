class Employee {
  String? dismissDate;
  String? empEmail;
  String? empName;
  String? hireDate;
  String? password;
  String? phone;
  String? roleID;
  String? scheduleID;
  String? seatNum;
  bool? status;
  String? token;

  Employee(
      {this.dismissDate,
      this.empEmail,
      this.empName,
      this.hireDate,
      this.password,
      this.phone,
      this.roleID,
      this.scheduleID,
      this.seatNum,
      this.status,
      this.token});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      dismissDate: json['dismissDate'],
      empEmail: json['empEmail'],
      empName: json['empName'],
      hireDate: json['hireDate'],
      password: json['password'],
      phone: json['phone'],
      roleID: json['roleID'],
      scheduleID: json['scheduleID'],
      seatNum: json['seatNum'],
      status: json['status'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dismissDate'] = this.dismissDate;
    data['empEmail'] = this.empEmail;
    data['empName'] = this.empName;
    data['hireDate'] = this.hireDate;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['roleID'] = this.roleID;
    data['scheduleID'] = this.scheduleID;
    data['seatNum'] = this.seatNum;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}
