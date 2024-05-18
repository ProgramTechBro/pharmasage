
import 'package:flutter/cupertino.dart';
import 'package:pharmasage/Model/POS/POSProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'POSProvider.dart';
class ReturnProvider with ChangeNotifier {
  List<InventoryProduct> _returnedProducts = [];
  double _returnTotalPrice = 0.0;
  // int _value =1;
  // int get value => _value;
  List<TextEditingController> quantityController=[];
  List<InventoryProduct> get returnedProducts => _returnedProducts;
  List <String> dropDownValues=[];
  double get returnTotalPrice => _returnTotalPrice;
  ReturnProvider(){
    setDropDownValues();
    setQuantityController();
  }
  void updateProductQuantity(int index, int quantity) {
    if (index >= 0 && index < _returnedProducts.length) {
      _returnedProducts[index].productQuantity = quantity;
      print('New Quantity ${_returnedProducts[index].productQuantity}');
       // double newSellingPrice=_returnedProducts[index].sellingPrice*returnedProducts[index].productQuantity;
       // _returnedProducts[index].sellingPrice=newSellingPrice;
      // Update total price based on the new quantity and product price
      int finalQuantity=quantity-1;
      _returnTotalPrice += ((_returnedProducts[index].sellingPrice ?? 0.0) * finalQuantity) ;
      updateReturnedProductQuantity(index, quantity);
      notifyListeners();
    }
  }
  void setQuantityController()
  {
    quantityController=[TextEditingController(text: '1')];
  }
  void changeDropDownValueAtIndex(int index, String newValue) {
    if (index >= 0 && index < dropDownValues.length) {
      dropDownValues[index] = newValue;
      notifyListeners();
    }
  }
  void addProductToBilling(InventoryProduct product) {
    print('its okay');
      product.productQuantity = 1; // Set the quantity to 1
      _returnedProducts.add(product);
      _returnTotalPrice += (product.sellingPrice ?? 0.0);
     // Add product price to total price
    notifyListeners();
  }
 void setDropDownValues(){
    //print(value);
    dropDownValues = ['Product']; // Initialize as empty list
    //dropDownValues = List.filled(value, 'Product');
 }
  void increaseProductQuantity(InventoryProduct product) {
    final index = _returnedProducts.indexWhere((p) => p.productID == product.productID);
    if (index != -1) {
      _returnedProducts[index].productQuantity = (_returnedProducts[index].productQuantity ?? 0) + 1;
      _returnTotalPrice += (product.sellingPrice ?? 0.0); // Add product price to total price
      notifyListeners();
    }
  }
  void IncreaseValue()
  {
    //_value++;
    dropDownValues.add('Product');
    quantityController.add(TextEditingController(text: '1'));
    notifyListeners();
  }
  void decreaseValue(){
    //_value++;
    dropDownValues.removeLast();
    quantityController.removeLast();
    notifyListeners();
  }
 void  updateReturnedProductQuantity(int index,int quantity){
    quantityController[index]=TextEditingController(text: quantity.toString());
  }
  void decreaseProductQuantity(InventoryProduct product) {
    final index = _returnedProducts.indexWhere((p) => p.productID == product.productID);
    if (index != -1 && _returnedProducts[index].productQuantity! > 1) {
      _returnedProducts[index].productQuantity = (_returnedProducts[index].productQuantity ?? 0) - 1;
      _returnTotalPrice -= (product.sellingPrice ?? 0.0); // Subtract product price from total price
      notifyListeners();
    }
  }
  void resetAllData(){
    _returnedProducts.clear();
    _returnTotalPrice=0.0;
    dropDownValues = ['Product'];
    quantityController = [TextEditingController(text: '1')];
    //print('Show Success Message');
    notifyListeners();

  }

}
