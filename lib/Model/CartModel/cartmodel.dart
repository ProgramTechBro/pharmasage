class Cart{
  int? id;
  String? productId;
  String? productName;
  String? productCompany;
  int? initialPrice;
  int? productPrice;
  String? productCategory;
  int? quantity;
  String? imagePath;
  Cart({required this.id,required this.productId,required this.productName,required this.productCompany,required this.initialPrice,required this.productPrice,required this.productCategory,required this.quantity,this.imagePath});
  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res['productId'],
        productName = res['productName'],
        productCompany=res['productCompany'],
        initialPrice = res['initialPrice'],
        productPrice = res['productPrice'],
        productCategory=res['productCategory'],
        quantity = res['quantity'],
        imagePath = res['imagePath'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productCompany':productCompany,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'productCategory':productCategory,
      'quantity': quantity,
      'imagePath': imagePath, // Include imagePath
    };
  }

}