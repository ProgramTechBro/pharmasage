import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../AdminController/StoreController.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
StoreController controller=StoreController();
class EmployeeProvider extends ChangeNotifier{
  File? employeeImage;
  String employeeImageUrL='';
  String updateEmployeeImageUrL='';
  //bool employeeSaving=false;
  fetchEmployeeImagesFromGallery({required BuildContext context}) async {
    employeeImage = await controller.pickImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  updateEmployeeImagesURL({required String imagesURLs}) async {
    employeeImageUrL =imagesURLs;
    notifyListeners();
  }
  emptyEmployeeImages() {
    employeeImage = null;
    employeeImageUrL='';
    notifyListeners();
  }
  // setStoreSaving()
  // {
  //   employeeSaving=!employeeSaving;
  //   notifyListeners();
  // }

}