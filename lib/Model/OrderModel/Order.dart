import 'dart:convert';
import '../Product/Productdetails.dart';
class OrderModel {
  late String? orderID;
  late String? orderDate;
  late String? orderTime;
  late String? orderStatus;
  late String? vendorName;
  late String? vendorEmail;
  late String? vendorContact;
  late int? totalAmount;
  late String? storeId;
  late List<Product>? orderedProducts;

  OrderModel({
    this.orderID,
    this.orderDate,
    this.orderTime,
    this.orderStatus,
    this.vendorName,
    this.vendorEmail,
    this.vendorContact,
    this.totalAmount,
    this.storeId,
    this.orderedProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderID': orderID,
      'orderDate': orderDate,
      'orderTime': orderTime,
      'orderStatus': orderStatus,
      'vendorName':vendorName,
      'vendorEmail':vendorEmail,
      'vendorContact':vendorContact,
      'totalAmount': totalAmount,
      'storeId': storeId,
      'orderedProducts': orderedProducts != null ? orderedProducts!.map((product) => product.toMap()).toList() : null,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderID: map['orderID'] != null ? map['orderID'] as String : null,
      orderDate: map['orderDate'] != null ? map['orderDate'] as String : null,
      orderTime: map['orderTime'] != null ? map['orderTime'] as String : null,
      orderStatus: map['orderStatus'] != null ? map['orderStatus'] as String : null,
      vendorName: map['vendorName'] != null ? map['vendorName'] as String : null,
      vendorEmail: map['vendorName'] != null ? map['vendorName'] as String : null,
      vendorContact: map['vendorContact'] != null ? map['vendorContact'] as String : null,
      totalAmount: map['totalAmount'] != null ? map['totalAmount'] as int : null,
      storeId: map['storeId'] != null ? map['storeId'] as String : null,
      orderedProducts: map['orderedProducts'] != null ? List<Product>.from((map['orderedProducts'] as List<dynamic>).map((item) => Product.fromMap(item as Map<String, dynamic>))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
