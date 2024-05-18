import 'dart:convert';

class Employees {
  late String? employeeImageURL;
  late String? employeeID;
  final String? employeeName;
  final String? employeeEmail;
  final String? employeeContact;
  final String? employeeCNIC;
  final String? employeePosition;
  final String? employeeSalary;
  final String? employeeBranchID;

  Employees({
    this.employeeImageURL,
    this.employeeID,
    this.employeeName,
    this.employeeEmail,
    this.employeeContact,
    this.employeeCNIC,
    this.employeePosition,
    this.employeeSalary,
    this.employeeBranchID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeImageURL':employeeImageURL,
      'employeeID': employeeID,
      'employeeName': employeeName,
      'employeeEmail': employeeEmail,
      'employeeContact': employeeContact,
      'employeeCNIC': employeeCNIC,
      'employeePosition': employeePosition,
      'employeeSalary': employeeSalary,
      'employeeBranchID': employeeBranchID,

    };
  }

  factory Employees.fromMap(Map<String, dynamic> map) {
    return Employees(
      employeeImageURL: map['employeeImageURL'] != null ? map['employeeImageURL'] as String : null,
      employeeID: map['employeeID'] != null ? map['employeeID'] as String : null,
      employeeName: map['employeeName'] != null ? map['employeeName'] as String : null,
      employeeEmail: map['employeeEmail'] != null ? map['employeeEmail'] as String : null,
      employeeContact: map['employeeContact'] != null ? map['employeeContact'] as String : null,
      employeeCNIC: map['employeeCNIC'] != null ? map['employeeCNIC'] as String : null,
      employeePosition: map['employeePosition'] != null ? map['employeePosition'] as String : null,
      employeeSalary: map['employeeSalary'] != null ? map['employeeSalary'] as String : null,
      employeeBranchID: map['employeeBranchID'] != null ? map['employeeBranchID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employees.fromJson(String source) =>
      Employees.fromMap(json.decode(source) as Map<String, dynamic>);
}
