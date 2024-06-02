import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class InventoryProduct {
  final String? productExpiry;
  final String? productImage;
  final String? productID;
  final String? productName;
  final String? productCategory;
   int? productQuantity;
  final int? lowStockWarning;
  final double? costPrice;
  final double? sellingPrice;
  //final String? password;
  InventoryProduct({
    this.productExpiry,
    this.productImage,
    this.productID,
    this.productName,
    this.productCategory,
    this.productQuantity,
    this.lowStockWarning,
    this.costPrice,
    this.sellingPrice,
    //this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productExpiry':productExpiry,
      'productImage': productImage,
      'productID': productID,
      'productName': productName,
      'productCategory': productCategory,
      'productQuantity':productQuantity,
      'lowStockWarning':lowStockWarning,
      'costPrice':costPrice,
      'sellingPrice':sellingPrice,
      //'password':password,
    };
  }

  factory InventoryProduct.fromMap(Map<String, dynamic> map) {
    return InventoryProduct(
      productExpiry: map['productExpiry'] != null
          ?map['productExpiry'] as String:null,
      productImage: map['productImage'] != null
          ?map['productImage'] as String:null,
      productID: map['productID'] != null ? map['productID'] as String : null,
      productName: map['productName'] != null ? map['productName'] as String : null,
      productCategory:
      map['productCategory'] != null ? map['productCategory'] as String : null,
      productQuantity:
      map['productQuantity'] != null ? map['productQuantity'] as int : null,
      lowStockWarning:
      map['lowStockWarning'] != null ? map['lowStockWarning'] as int : null,
      costPrice: map['costPrice'] != null ? (map['costPrice'] as num).toDouble() : null,
      sellingPrice: map['sellingPrice'] != null ? (map['sellingPrice'] as num).toDouble() : null,
      // costPrice: map['costPrice'] != null ? map['costPrice'] as double : null,
      // sellingPrice: map['sellingPrice'] != null ? map['sellingPrice'] as double : null,


    );
  }
  factory InventoryProduct.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return InventoryProduct(
      productExpiry: data['productExpiry'] != null ? data['productExpiry'] as String : null,
      productImage: data['productImage'] != null ? data['productImage'] as String : null,
      productID: data['productID'] != null ? data['productID'] as String : null,
      productName: data['productName'] != null ? data['productName'] as String : null,
      productCategory: data['productCategory'] != null ? data['productCategory'] as String : null,
      productQuantity: data['productQuantity'] != null ? data['productQuantity'] as int : null,
      lowStockWarning: data['lowStockWarning'] != null ? data['lowStockWarning'] as int : null,
      costPrice: data['costPrice'] != null ? (data['costPrice'] as num).toDouble() : null,
      sellingPrice: data['sellingPrice'] != null ? (data['sellingPrice'] as num).toDouble() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryProduct.fromJson(String source) =>
      InventoryProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
