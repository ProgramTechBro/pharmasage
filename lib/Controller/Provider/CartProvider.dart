import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartProvider with ChangeNotifier{
  int _count=0;
  int _quantity=1;
  int get quantity=>_quantity;
  int get count =>_count;
  double _totalprice=0.0;
  double get totalprice=>_totalprice;
  void _setpref()async{
    SharedPreferences ref= await SharedPreferences.getInstance();
    ref.setInt('cart_item',_count );
    ref.setDouble('total_prices', _totalprice);
    ref.setInt('pro_quantity', _quantity);
    notifyListeners();
  }
  void _getpref()async{
    SharedPreferences ref= await SharedPreferences.getInstance();
    _count=ref.getInt('cart_item')??0;
    _totalprice=ref.getDouble('total_prices')??0.0;
    _quantity=ref.getInt('pro_quantity')??0;
    notifyListeners();
  }
  void resetPref()async{
    SharedPreferences ref= await SharedPreferences.getInstance();
    ref.setInt('cart_item',0 );
    ref.setDouble('total_prices',0.0);
    ref.setInt('pro_quantity',0);
    notifyListeners();
  }
  void addcounter()
  {
    _count++;
    _setpref();
    notifyListeners();
  }
  void removecounter()
  {
    _count--;
    _setpref();
    notifyListeners();
  }
  int getcounter()
  {
    _getpref();
    return _count;
  }
  void addtotalPrice(double productprice)
  {
    _totalprice=_totalprice+productprice;
    _setpref();
    notifyListeners();
  }
  void removetotalPrice(double productprice)
  {
    _totalprice=_totalprice-productprice;
    _setpref();
    notifyListeners();
  }
  double gettotalprice(){
    _getpref();
    return _totalprice;
  }
  void addquantity()
  {
    _quantity++;
    _setpref();
    notifyListeners();
  }
  void removequantity()
  {
    _quantity--;
    _setpref();
    notifyListeners();
  }
  int gettotalquantity()
  {
    _getpref();
    return _quantity;
  }

}