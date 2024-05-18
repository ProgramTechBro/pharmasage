import 'dart:convert';
import '../ReturnProduct/ReturnProduct.dart';
class ReturnedProductModel {
  late String? returnID;
  late String? returnDate;
  late String? returnTime;
  late String? returnAgainst;
  late String? storeName;
  late String? storeLocation;
  late double? totalAmount;
  late String? comment;
  late List<ReturnProduct>? selectedReturnedProducts;

  ReturnedProductModel({
    this.returnID,
    this.returnDate,
    this.returnTime,
    this.returnAgainst,
    this.storeName,
    this.storeLocation,
    this.totalAmount,
    this.comment,
    this.selectedReturnedProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'returnID': returnID,
      'returnDate': returnDate,
      'returnTime': returnTime,
      'returnAgainst':returnAgainst,
      'storeName': storeName,
      'storeLocation':storeLocation,
      'totalAmount':totalAmount,
      'comment':comment,
      'selectedProducts': selectedReturnedProducts != null ? selectedReturnedProducts!.map((product) => product.toMap()).toList() : null,
    };
  }

  factory ReturnedProductModel.fromMap(Map<String, dynamic> map) {
    return ReturnedProductModel(
      returnID: map['returnID'] != null ? map['returnID'] as String : null,
      returnDate: map['returnDate'] != null ? map['returnDate'] as String : null,
      returnTime: map['returnTime'] != null ? map['returnTime'] as String : null,
      returnAgainst: map['returnAgainst'] != null ? map['returnAgainst'] as String : null,
      storeName: map['storeName'] != null ? map['storeName'] as String : null,
      storeLocation: map['storeLocation'] != null ? map['storeLocation'] as String : null,
      totalAmount: map['totalAmount'] != null ? map['totalAmount'] as double : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      selectedReturnedProducts: map['selectedReturnedProducts'] != null ? List<ReturnProduct>.from((map['selectedReturnedProducts'] as List<dynamic>).map((item) => ReturnProduct.fromMap(item as Map<String, dynamic>))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnedProductModel.fromJson(String source) =>
      ReturnedProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
