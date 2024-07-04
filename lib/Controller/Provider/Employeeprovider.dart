
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
  File? updatedEmployeeImage;
  bool updateSaving=false;
  fetchEmployeeImagesFromGallery({required BuildContext context}) async {
    employeeImage = await controller.pickImage(context);
    notifyListeners();
  }
  fetchUpdatedEmployeeImageFromGallery({required BuildContext context})async{
    updatedEmployeeImage = await controller.pickImage(context);
    notifyListeners();
  }
  updatedUpdatedEmployeeImageURL({required String imagesURLs}){
    updateEmployeeImageUrL=imagesURLs;
    notifyListeners();
  }
  emptyUpdatedEmployeeImagesURL(){
    updatedEmployeeImage=null;
    updateEmployeeImageUrL='';
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
  updateEmployeeUpdateSaving(){
    updateSaving=!updateSaving;
    notifyListeners();
  }
  removeUpdatedEmployeeImage(){
    updatedEmployeeImage=null;
    notifyListeners();
  }
}