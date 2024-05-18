import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/Model/BranchManager/BranchManager.dart';
import '../../Model/User/vendordetails.dart';
import 'ProductProvider.dart';
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
UserController profile=UserController();
class AdminProvider extends ChangeNotifier{
  bool loading=false;
  bool isSaving=false;
  bool roleUpdate=false;
  String Branchid='';
  String currentBranch='';
  File? vendorImage;
  File? branchManagerProfileImage;
  bool isProductSaving=false;
  String role='';
  String? vendorImageUrL;
  String? bmImageUrl;
  UserProfile vendorDetail=UserProfile();
  String currentUserImage='';
  BranchManagerData bm=BranchManagerData();
  String? imageUrl;
  int secondRemaining=30;
  String timerText = '30';
  bool isReady=true;
  AdminProvider()
  {
    loadUserDataIntoMemory();
  }
  updateLoader(){
   loading=!loading;
   notifyListeners();
  }
  changeStatus()
  {
    isReady=!isReady;
    notifyListeners();
  }
   fetchData(UserProfile detail) {
    print('g aya');
    vendorDetail=detail;
    notifyListeners();
  }
  Future<String?> openCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imageUrl = pickedImage.path;
      //vendorDetail.imagesURL=pickedImage.path;
      notifyListeners();
      //print(pickedImage.path);
      return pickedImage.path;
    }

    return null;
  }
  void resetImageUrl() {
    vendorImageUrL = '';
    // Notify listeners after resetting imageUrl
    notifyListeners();
  }
  void resetBMImageUrl() {
    bmImageUrl = '';
    // Notify listeners after resetting imageUrl
    notifyListeners();
  }
 //  updateImageUrl(String url)
 //  {
 //    imageUrl=url;
 //    notifyListeners();
 // }
  setSavingStatus()
  {
    isSaving=!isSaving;
    notifyListeners();
  }
  fetchVendorImagesFromGallery({required BuildContext context}) async {
    vendorImage = await controller.pickImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  fetchBMImagesFromGallery({required BuildContext context}) async {
    branchManagerProfileImage = await controller.pickImage(context);
    //updateProductImagesURL(imagesURLs: productImage!.path);
    notifyListeners();
  }
  updateVendorImagesURL({required String imagesURLs}) async {
    vendorImageUrL =imagesURLs;
    notifyListeners();
  }
  updateBMImagesURL({required String imagesURLs}) async {
    bmImageUrl =imagesURLs;
    notifyListeners();
  }

  emptyVendorImages(String imageName) async{
    //await profile.deleteImageFromFirebaseStorage(imageName);
    vendorImage = null;
    vendorImageUrL='';
    notifyListeners();
  }
  emptyBMImages(String imageName) async{
    //await profile.deleteImageFromFirebaseStorage(imageName);
     branchManagerProfileImage= null;
    bmImageUrl='';
    notifyListeners();
  }
  loadUserDataIntoMemory()async
  {
    Completer completer = Completer();
    print('hehe');
    if(_auth.currentUser?.email!=null)
      {
        await getUserData();
      }
    else
      {
        log('User not Available');
      }
    completer.complete(role);
    notifyListeners();
    return completer.future;
  }
  Future<void> getUserData() async {
    final snapshot = await fireStore.collection('Users').doc(_auth.currentUser!.email).get();
    print('HiFI');
    final person = snapshot.data() as Map<String, dynamic>;
    if (person['role'] == 'Pharmacist' || person['role'] == 'Vendor') {
      // Convert the person map to a JSON string
      final personJson = json.encode(person);
      vendorDetail = UserProfile.fromJson(personJson);
      currentUserImage=vendorDetail.imagesURL!;
      role=vendorDetail.role!;
    } else {
      final personJson = json.encode(person);
      bm = BranchManagerData.fromJson(personJson);
      currentUserImage=bm.branchManagerImage!;
      role=bm.role!;
      Branchid=bm.branchID!;
    }
    print('Done Done Done');
    print(role);
  }


  removeVendorImage()
  {
    vendorImage=null;
    notifyListeners();
  }
  removeBMImage()
  {
    branchManagerProfileImage=null;
    notifyListeners();
  }
  updateRole(String role)
  {
    role=role;
  }
  setUpdateStatus()
  {
    roleUpdate=!roleUpdate;
    notifyListeners();
  }
  updateCurrentBranch(String id)
  {
    currentBranch=id;
    notifyListeners();
  }
}