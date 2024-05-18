import 'dart:convert';
class Product {
  final String? productSellerId;
  final String? productImage;
  final String? productID;
  final String? productName;
  final String? productCategory;
  final String? productCompany;
  final double? productPrice;
  final int? quantity;
  //final String? password;
  Product({
    this.productSellerId,
    this.productImage,
    this.productID,
    this.productName,
    this.productCategory,
    this.productCompany,
    this.productPrice,
    this.quantity,
    //this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productSellerId':productSellerId,
      'productImage': productImage,
      'productID': productID,
      'productName': productName,
      'productCategory': productCategory,
      'productCompany':productCompany,
      'productPrice':productPrice,
      'quantity':quantity,
      //'password':password,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productSellerId: map['productSellerId'] != null
          ?map['productSellerId'] as String:null,
      productImage: map['productImage'] != null
          ?map['productImage'] as String:null,
      productID: map['productID'] != null ? map['productID'] as String : null,
      productName: map['productName'] != null ? map['productName'] as String : null,
      productCategory:
      map['productCategory'] != null ? map['productCategory'] as String : null,
      productCompany:
      map['productCompany'] != null ? map['productCompany'] as String : null,
      productPrice:
      map['productPrice'] != null ? map['productPrice'] as double : null,
      quantity:
      map['quantity'] != null ? map['quantity'] as int : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
