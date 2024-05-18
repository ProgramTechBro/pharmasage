import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../AdminController/StoreController.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
StoreController controller=StoreController();
class StoreProvider extends ChangeNotifier{
  File? storeImage;
  String storeImageUrL='';
  String updateStoreImageUrL='';
  bool storeSaving=false;
  fetchStoreImagesFromGallery({required BuildContext context}) async {
    storeImage = await controller.pickImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  updateStoreImagesURL({required String imagesURLs}) async {
    storeImageUrL =imagesURLs;
    notifyListeners();
  }
  emptyStoreImages() {
    storeImage = null;
    storeImageUrL='';
    notifyListeners();
  }
  setStoreSaving()
  {
    storeSaving=!storeSaving;
    notifyListeners();
  }

}