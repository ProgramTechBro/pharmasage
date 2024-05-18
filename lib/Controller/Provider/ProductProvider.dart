import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
OrderController controller=OrderController();
class ProductProvider extends ChangeNotifier{
  File? productImage;
  bool isProductSaving=false;
  String imageUrL='';
  changeProductSavingStatus()
  {
    isProductSaving=!isProductSaving;
  }
  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImage = await controller.pickImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  updateProductImagesURL({required String imagesURLs}) async {
    imageUrL =imagesURLs;
    notifyListeners();
  }
  emptyProductImages() {
    productImage = null;
    imageUrL='';
    notifyListeners();
  }

}