import 'dart:convert';
class ReturnProduct {
  final String? productID;
  final String? productName;
  int? productQuantity;
  final double? returnProductPrice;
  //final String? password;
  ReturnProduct({
    this.productID,
    this.productName,
    this.productQuantity,
    this.returnProductPrice,
    //this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productID':productID,
      'productName': productName,
      'productQuantity':productQuantity,
      'returnProductPrice':returnProductPrice,
      //'password':password,
    };
  }

  factory ReturnProduct.fromMap(Map<String, dynamic> map) {
    return ReturnProduct(
      productID: map['productID'] != null ? map['productID'] as String : null,
      productName: map['productName'] != null ? map['productName'] as String : null,
      productQuantity:
      map['productQuantity'] != null ? map['productQuantity'] as int : null,
      returnProductPrice:
      map['returnProductPrice'] != null ? map['returnProductPrice'] as double : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnProduct.fromJson(String source) =>
      ReturnProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
