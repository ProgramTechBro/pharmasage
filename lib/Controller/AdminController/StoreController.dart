import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../Provider/Authprovider.dart';
import '../Provider/StoreProvider.dart';
FirebaseAuth auth=FirebaseAuth.instance;
FirebaseStorage storage=FirebaseStorage.instance;
FirebaseFirestore firestore=FirebaseFirestore.instance;
class StoreController {
  Future<File?> pickImage(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      CommonFunctions.showWarningToast(
        context: context,
        message: 'No Image Selected',
      );
      return null; // Return null when no image is selected
    }
  }

  static uploadImageToFirebaseStorage({
    required File images,
    required BuildContext context,
    required String imageNAme,
  }) async {


    String imageName = '$imageNAme.jpg';
    Reference ref = storage.ref().child('Stores_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    Provider.of<StoreProvider>(context, listen: false).updateStoreImagesURL(
        imagesURLs: imageURL);
  }

  static Future<void> addStore({
    required BuildContext context,
    required MedicalStore storeModel,
  }) async {
    try {
    firestore.collection('Medical Stores')
        .doc(storeModel.branchID)
        .set(storeModel.toMap());
      log('Data Added');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Store Added Successful');
      Provider.of<StoreProvider>(context,listen: false).emptyStoreImages();
    } catch (e) {
      print('idr aya############');
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  static Future<void> deleteStore({
    required BuildContext context,
    required String branchID,
  }) async {
    try {
      String imageName='$branchID.jpg';
      await deleteImageFromFirebaseStorage(imageName);
      await firestore.collection('Medical Stores')
          .doc(branchID) // Use StoreId as document ID
          .delete(); // Delete the document
      log('Store Deleted');
      //Navigator.pop(context);
      CommonFunctions.showSuccessToast(
          context: context, message: 'Store Deleted');
    } catch (e) {
      log('Error deleting store: $e');
      CommonFunctions.showErrorToast(context: context, message: 'Failed to delete store');
    }
  }

  static Future<void> deleteImageFromFirebaseStorage(String imageName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Product_Images').child(imageName);
      await ref.delete();
      print('Image deleted from Firebase Storage: $imageName');
    } catch (e) {
      print('Error deleting image from Firebase Storage: $e');
    }
  }

}