import 'dart:convert';

class BranchManagerData {
  late String? branchManagerImage;
  final String? bMFullName;
  final String? bMUserName;
  final String? bMPassword;
  final String? branchID;
  final String? role;

  BranchManagerData({
    this.branchManagerImage,
    this.bMFullName,
    this.bMUserName,
    this.bMPassword,
    this.branchID,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchManagerImage': branchManagerImage,
      'bMFullName': bMFullName,
      'bMUserName': bMUserName,
      'bMPassword': bMPassword,
      'branchID': branchID,
      'role': role,
    };
  }

  factory BranchManagerData.fromMap(Map<String, dynamic> map) {
    return BranchManagerData(
      branchManagerImage: map['branchManagerImage'] != null ? map['branchManagerImage'] as String : null,
      bMFullName: map['bMFullName'] != null ? map['bMFullName'] as String : null,
      bMUserName: map['bMUserName'] != null ? map['bMUserName'] as String : null,
      bMPassword: map['bMPassword'] != null ? map['bMPassword'] as String : null,
      branchID: map['branchID'] != null ? map['branchID'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchManagerData.fromJson(String source) =>
      BranchManagerData.fromMap(json.decode(source) as Map<String, dynamic>);
}
