class InventoryCart{
  int? id;
  String? productId;
  String? productExpiry;
  String? productName;
  //String? productCompany;
  int? initialPrice;
  int? productPrice;
  String? productCategory;
  int? productQuantity;
  int? lowStockWarning;
  String? imagePath;
  InventoryCart({required this.id,required this.productId,required this.productExpiry,required this.productName,required this.initialPrice,required this.productPrice,required this.productCategory,required this.productQuantity,required this.lowStockWarning,this.imagePath});
  InventoryCart.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res['productId'],
  productExpiry=res['productExpiry'],
        productName = res['productName'],
        //productCompany=res['productCompany'],
        initialPrice = res['initialPrice'],
        productPrice = res['productPrice'],
        productCategory=res['productCategory'],
        productQuantity = res['productQuantity'],
  lowStockWarning=res['lowStockWarning'],
        imagePath = res['imagePath'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productExpiry':productExpiry,
      'productName': productName,
      //'productCompany':productCompany,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'productCategory':productCategory,
      'lowStockWarning':lowStockWarning,
      'productQuantity': productQuantity,
      'imagePath': imagePath, // Include imagePath
    };
  }

}