import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/Provider/InventoryCartProvider.dart';
import 'package:pharmasage/Controller/Provider/ReturnProvider.dart';
import 'package:pharmasage/Model/OrderModel/Order.dart';
import 'package:pharmasage/Model/POS/POSProduct.dart';
import 'package:pharmasage/Model/Product/Productdetails.dart';
import 'package:pharmasage/Model/ReturnModel/ReturnModel.dart';
import 'package:pharmasage/Model/Transaction/TransactionDetails.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Provider/POSProvider.dart';
import '../Provider/ProductProvider.dart';
FirebaseAuth auth=FirebaseAuth.instance;
FirebaseStorage storage=FirebaseStorage.instance;
FirebaseFirestore fireStore=FirebaseFirestore.instance;
Uint8List? selectedImageInBytes;
class POSController {
  Future<Uint8List?> pickPOSImage(BuildContext context) async {
    // final pickedImage = await ImagePicker().pickImage(
    //   source: ImageSource.gallery,
    // );
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final selectFile=result.files.first.name;
      selectedImageInBytes=result.files.first.bytes;
      return selectedImageInBytes;
    } else {
      CommonFunctions.showWarningToast(
        context: context,
        message: 'No Image Selected',
      );
      return null; // Return null when no image is selected
    }
  }

  static Future<void> uploadPOSProductImageToFirebaseStorage({
    required Uint8List images,
    required BuildContext context,
    required dynamic imageNAme,
  }) async {
    try {
      print('Images $images');
      // Create a temporary file
     //  final tempDir = await getTemporaryDirectory();
     //  final tempPath = tempDir.path;
     //  final file = File('$tempPath/$imageNAme.jpg');
     //  // Write the image bytes to the file
     //  await file.writeAsBytes(images);
     //  print('File :  ******');
     // print(file);
      // Upload the file to Firebase Storage
      String imageName = '$imageNAme.jpg';
      Reference ref = storage.ref().child('Inventory_Images').child(imageName);
      final metaData = SettableMetadata(contentType: 'images/png');
      await ref.putData(images);
      // Get the download URL and update the provider
      String imageURL = await ref.getDownloadURL();
      Provider.of<POSProvider>(context, listen: false)
          .updatePOSProductImagesURL(imagesURLs: imageURL);

      print('Upload successful');
    } catch (error) {
      print('Error uploading image: $error');
    }
  }


  static Future<void> addProduct({
    required BuildContext context,
    required InventoryProduct productModel,
    required String storeId,
  }) async {
    try {
      await fireStore
          .collection('Inventory')
          .doc(storeId)
      .collection('Products').doc(productModel.productID)
          .set(productModel.toMap()); // Set product details as document fields
      log('Data Added');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Product Added');
      Provider.of<POSProvider>(context,listen: false).emptyPOSProductImages();
    } catch (e) {
      print('idr aya############');
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  static Future<void> addTransaction({
    required BuildContext context,
    required TransactionModel model,
    required String storeId,
  }) async {
    try {
      print('Hello');
      // Add the order to the 'Orders' collection
      await fireStore
          .collection('Transactions')
          .doc(storeId)
           .collection('TransactionID').doc(model.transactionID)
          .set(model.toMap());
      for (var product in model.selectedProducts!) {
        // Retrieve the document reference for the product
        DocumentReference productRef = FirebaseFirestore.instance
            .collection('Inventory')
            .doc(storeId)
            .collection('Products')
            .doc(product.productID);

        // Get the current product data
        DocumentSnapshot productSnapshot = await productRef.get();
        Map<String, dynamic>? productData = (productSnapshot.data() as Map<String, dynamic>?) ?? {};
        // Update the quantity
        int currentQuantity = productData['productQuantity'] ?? 0;
        int soldQuantity = product.productQuantity ?? 0;
        int newQuantity = currentQuantity - soldQuantity;
        print('New Quantity $newQuantity');
        newQuantity = newQuantity < 0 ? 0 : newQuantity; // Ensure quantity doesn't go negative

        // Update the product quantity in Firestore
        await productRef.update({'productQuantity': newQuantity});
      }
      Provider.of<POSProvider>(context,listen: false).resetTID();
      Provider.of<InventoryCartProvider>(context,listen: false).resetBilling();
      // Show success message
      CommonFunctions.showSuccessToast(
          context: context, message: 'Billing Completed');
    } catch (e) {
      print('Error occurred: $e');
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }

  }
  static Future<TransactionModel?> fetchTransactionById(
      {required String storeId, required String transactionId}) async {
    try {
      // Retrieve the document reference for the transaction
      DocumentSnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(storeId)
          .collection('TransactionID')
          .doc(transactionId)
          .get();
      print('yaha tak aya');
      // Check if the transaction exists
      if (transactionSnapshot.exists) {
        // Convert transaction data to a map
        Map<String, dynamic>? transactionData =
        transactionSnapshot.data() as Map<String, dynamic>?;
        print('yaha bhi tak aya');
        // Create a TransactionModel object from the map data
        if (transactionData != null) {
          TransactionModel transaction =
          TransactionModel.fromMap(transactionData);
          return transaction;
        }
      }

      // If transaction doesn't exist or data is invalid, return null
      return null;
    } catch (e) {
      // Handle any errors
      print('Error fetching transaction: $e');
      return null;
    }
  }
  static Future<void> addReturnedTransaction({
    required BuildContext context,
    required ReturnedProductModel model,
    required String storeId,
  }) async {
    try {
      print('Hello');
      // Add the order to the 'Orders' collection
      await fireStore
          .collection('ReturnedTransactions')
          .doc(storeId)
          .collection('ReturnID').doc(model.returnID)
          .set(model.toMap());
      for (var product in model.selectedReturnedProducts!) {
        // Retrieve the document reference for the product
        DocumentReference productRef = FirebaseFirestore.instance
            .collection('Inventory')
            .doc(storeId)
            .collection('Products')
            .doc(product.productID);

        // Get the current product data
        DocumentSnapshot productSnapshot = await productRef.get();
        Map<String, dynamic>? productData = (productSnapshot.data() as Map<String, dynamic>?) ?? {};
        // Update the quantity
        int currentQuantity = productData['productQuantity'] ?? 0;
        int returnQuantity = product.productQuantity ?? 0;
        int newQuantity = currentQuantity + returnQuantity;
        print('New Quantity $newQuantity');
        newQuantity = newQuantity < 0 ? 0 : newQuantity; // Ensure quantity doesn't go negative

        // Update the product quantity in Firestore
        await productRef.update({'productQuantity': newQuantity});
      }
     // print('hello DB124//////////////////');
      // CommonFunctions.showSuccessToast(
      //     context: context, message: 'Return Completed');
      Provider.of<POSProvider>(context,listen: false).updateAfterReturned();
     Provider.of<ReturnProvider>(context,listen: false).resetAllData();
     //print('Yaha tak ata ha bus');
      // Show success message
      CommonFunctions.showSuccessToast(
          context: context, message: 'Return Completed');
    } catch (e) {
      print('Error occurred: $e');
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }

  }

}