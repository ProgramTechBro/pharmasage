import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmasage/Model/POS/POSProduct.dart';

class TransactionModel {
  late String? transactionID;
  late String? transactionDate;
  late String? transactionTime;
  late String? storeName;
  late String? storeLocation;
  late double? subTotalAmount;
  late double? tax;
  late double? totalAmount;
  late List<InventoryProduct>? selectedProducts;

  TransactionModel({
    this.transactionID,
    this.transactionDate,
    this.transactionTime,
    this.storeName,
    this.storeLocation,
    this.subTotalAmount,
    this.tax,
    this.totalAmount,
    this.selectedProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionID': transactionID,
      'transactionDate': transactionDate,
      'transactionTime': transactionTime,
      'storeName': storeName,
      'storeLocation':storeLocation,
      'subTotalAmount':subTotalAmount,
      'tax':tax,
      'totalAmount': totalAmount,
      'selectedProducts': selectedProducts != null ? selectedProducts!.map((product) => product.toMap()).toList() : null,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionID: map['transactionID'] != null ? map['transactionID'] as String : null,
      transactionDate: map['transactionDate'] != null ? map['transactionDate'] as String : null,
      transactionTime: map['transactionTime'] != null ? map['transactionTime'] as String : null,
      storeName: map['storeName'] != null ? map['storeName'] as String : null,
      storeLocation: map['storeLocation'] != null ? map['storeLocation'] as String : null,
      subTotalAmount: map['subTotalAmount'] != null ? map['subTotalAmount'] as double : null,
      tax: map['tax'] != null ? map['tax'] as double : null,
      totalAmount: map['totalAmount'] != null ? map['totalAmount'] as double : null,
      selectedProducts: map['selectedProducts'] != null ? List<InventoryProduct>.from((map['selectedProducts'] as List<dynamic>).map((item) => InventoryProduct.fromMap(item as Map<String, dynamic>))) : null,
    );
  }
  TransactionModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    transactionID = data['transactionID'] as String?;
    transactionDate = data['transactionDate'] as String?;
    transactionTime = data['transactionTime'] as String?;
    storeName = data['storeName'] as String?;
    storeLocation = data['storeLocation'] as String?;
    subTotalAmount = (data['subTotalAmount'] ?? 0).toDouble();
    tax = (data['tax'] ?? 0).toDouble();
    totalAmount = (data['totalAmount'] ?? 0).toDouble();
    if (data['selectedProducts'] != null) {
      selectedProducts = List<InventoryProduct>.from(
        (data['selectedProducts'] as List<dynamic>).map(
              (item) => InventoryProduct.fromMap(item as Map<String, dynamic>),
        ),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
