import 'dart:convert';
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

  String toJson() => json.encode(toMap());

  factory InventoryProduct.fromJson(String source) =>
      InventoryProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
