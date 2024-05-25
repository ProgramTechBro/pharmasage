import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
import 'package:pharmasage/Model/InventoryCartModel/InevntoryCart.dart';
import 'package:pharmasage/View/InventoryDatabase.dart';

import '../AdminController/POSController.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
POSController controller=POSController();
class POSProvider extends ChangeNotifier{
  Uint8List? posProductImage;
  bool isPosProductSaving=false;
  String tID='';
  int returnProductQuantity=1;
  InventoryDatabaseHelper db=InventoryDatabaseHelper();
   late Future<List<InventoryCart>> products;
  String posImageUrL='';
  POSProvider() {
    // Initialize products variable with an empty Future
    products = Future.value([]);
  }
  changeProductSavingStatus()
  {
    isPosProductSaving=!isPosProductSaving;
  }
  fetchPOSProductImagesFromGallery({required BuildContext context}) async {
    posProductImage = await controller.pickPOSImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  updatePOSProductImagesURL({required String imagesURLs}) async {
    posImageUrL =imagesURLs;
    notifyListeners();
  }
  emptyPOSProductImages() {
    posProductImage = null;
    posImageUrL='';
    notifyListeners();
  }
  removePOSImage(){
    posProductImage = null;
    notifyListeners();
  }
  updateTID(String newValue)
  {
    tID=newValue;
    notifyListeners();
  }
  getInventoryCartProduct()
  {
    products=db.getnoteslist();
    notifyListeners();
  }
  resetTID()
  {
    tID='';
    notifyListeners();
  }
  increaseReturnProductQuantity()
  {
    returnProductQuantity++;
    notifyListeners();
  }
  decreaseReturnProductQuantity()
  {
    returnProductQuantity--;
    notifyListeners();
  }
  updateAfterReturned()
  {
    returnProductQuantity=1;
    notifyListeners();
  }
}
