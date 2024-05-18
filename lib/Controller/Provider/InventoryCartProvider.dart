import 'package:flutter/cupertino.dart';
import 'package:pharmasage/Model/POS/POSProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
class InventoryCartProvider with ChangeNotifier {
  List<InventoryProduct> _selectedProducts = [];
  double _totalPrice = 0.0;
  List<InventoryProduct> get selectedProducts => _selectedProducts;

  double get totalPrice => _totalPrice;

  void addProductToBilling(InventoryProduct product) {
    product.productQuantity = 1; // Set the quantity to 1
    _selectedProducts.add(product);
    _totalPrice += (product.sellingPrice ?? 0.0); // Add product price to total price
    notifyListeners();
  }

  void increaseProductQuantity(InventoryProduct product) {
    final index = _selectedProducts.indexWhere((p) => p.productID == product.productID);
    if (index != -1) {
      _selectedProducts[index].productQuantity = (_selectedProducts[index].productQuantity ?? 0) + 1;
      _totalPrice += (product.sellingPrice ?? 0.0); // Add product price to total price
      notifyListeners();
    }
  }

  void decreaseProductQuantity(InventoryProduct product) {
    final index = _selectedProducts.indexWhere((p) => p.productID == product.productID);
    if (index != -1 && _selectedProducts[index].productQuantity! > 1) {
      _selectedProducts[index].productQuantity = (_selectedProducts[index].productQuantity ?? 0) - 1;
      _totalPrice -= (product.sellingPrice ?? 0.0); // Subtract product price from total price
      notifyListeners();
    }
  }

  void removeProductFromBilling(InventoryProduct product) {
    _selectedProducts.removeWhere((p) => p.productID == product.productID);
    _totalPrice -= (product.sellingPrice ?? 0.0); // Subtract product price from total price
    notifyListeners();
  }
  void resetBilling() {
    _selectedProducts.clear();
    _totalPrice = 0.0;
    notifyListeners();
  }
}

//int _count=0;
  // int _quantity=1;
  // int get quantity=>_quantity;
  // //int get count =>_count;
  // double _totalprice=0.0;
  // double get totalprice=>_totalprice;
  // // void _setpref()async{
  // //   SharedPreferences ref= await SharedPreferences.getInstance();
  // //   ref.setInt('cart_item',_count );
  // //   ref.setDouble('total_prices', _totalprice);
  // //   ref.setInt('pro_quantity', _quantity);
  // //   notifyListeners();
  // // }
  // // void _getpref()async{
  // //   SharedPreferences ref= await SharedPreferences.getInstance();
  // //   _count=ref.getInt('cart_item')??0;
  // //   _totalprice=ref.getDouble('total_prices')??0.0;
  // //   _quantity=ref.getInt('pro_quantity')??0;
  // //   notifyListeners();
  // // }
  // // void resetPref()async{
  // //   SharedPreferences ref= await SharedPreferences.getInstance();
  // //   ref.setInt('cart_item',0 );
  // //   ref.setDouble('total_prices',0.0);
  // //   ref.setInt('pro_quantity',0);
  // //   notifyListeners();
  // // }
  // // void addcounter()
  // // {
  // //   _count++;
  // //   //_setpref();
  // //   notifyListeners();
  // // }
  // // void removecounter()
  // // {
  // //   _count--;
  // //   //_setpref();
  // //   notifyListeners();
  // // }
  // // int getcounter()
  // // {
  // //   //_getpref();
  // //   return _count;
  // // }
  // void addtotalPrice(double productprice)
  // {
  //   _totalprice=_totalprice+productprice;
  //   //_setpref();
  //   notifyListeners();
  // }
  // void removetotalPrice(double productprice)
  // {
  //   _totalprice=_totalprice-productprice;
  //   //_setpref();
  //   notifyListeners();
  // }
  // double gettotalprice(){
  //   //_getpref();
  //   return _totalprice;
  // }
  // void addquantity()
  // {
  //   _quantity++;
  //   //_setpref();
  //   notifyListeners();
  // }
  // void removequantity()
  // {
  //   _quantity--;
  //   //_setpref();
  //   notifyListeners();
  // }
  // int gettotalquantity()
  // {
  //   //_getpref();
  //   return _quantity;
  // }

