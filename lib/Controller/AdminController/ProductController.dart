import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Model/OrderModel/Order.dart';
import 'package:pharmasage/Model/Product/Productdetails.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Provider/ProductProvider.dart';
FirebaseAuth auth=FirebaseAuth.instance;
FirebaseStorage storage=FirebaseStorage.instance;
class OrderController {
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
    required imageNAme,
  }) async {
    String sellerUID = auth.currentUser!.email!;
    Uuid uuid = const Uuid();

    String imageName = '$imageNAme.jpg';
    Reference ref = storage.ref().child('Product_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    Provider.of<ProductProvider>(context, listen: false).updateProductImagesURL(
        imagesURLs: imageURL);
  }

  static Future<void> addProduct({
    required BuildContext context,
    required Product productModel,
  }) async {
    try {
      await fireStore
          .collection('Products')
          .doc(productModel.productSellerId) // Use seller ID as document ID
          .collection('SellerProducts') // Collection for seller's products
          .doc(productModel.productID) // Use product ID as document ID
          .set(productModel.toMap()); // Set product details as document fields
      log('Data Added');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Product Added Successful');
      Provider.of<ProductProvider>(context,listen: false).emptyProductImages();
    } catch (e) {
      print('idr aya############');
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  static Future<void> addOrder({
    required BuildContext context,
    required OrderModel model,
  }) async {
    try {
      print('Hello');
      // Add the order to the 'Orders' collection
      await fireStore
          .collection('Orders')
          .doc(model.orderID)
          .set(model.toMap());

      // Add the order to the 'ReceivedOrders' collection
      await fireStore
          .collection('ReceivedOrders')
          .doc(model.orderID)
          .set(model.toMap());

      // Show success message
      CommonFunctions.showSuccessToast(
          context: context, message: 'Order Placed');

      // Empty product images after order placement
      Provider.of<ProductProvider>(context, listen: false)
          .emptyProductImages();
    } catch (e) {
      print('Error occurred: $e');
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  Future<void> rejectOrder({required BuildContext context,required String orderId}) async {
    try {
      // Update order status to 'Rejected' in the Orders collection
      await fireStore
          .collection('Orders')
          .doc(orderId)
          .update({'orderStatus': 'Rejected'});

      // Remove the order from the ReceivedOrders collection
      await fireStore
          .collection('ReceivedOrders')
          .doc(orderId)
          .delete();

      print('Order $orderId rejected successfully.');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Order Rejected');
    } catch (e) {
      print('Error rejecting order: $e');
      // Handle any errors here
    }
  }
  Future<void> acceptOrder({required BuildContext context, required String orderId, required Map<String, dynamic> orderData}) async {
    try {
      // Update order status to 'Accepted' in the Orders collection
      await fireStore
          .collection('Orders')
          .doc(orderId)
          .update({'orderStatus': 'Accepted'});

      // Delete the order from the ReceivedOrders collection
      await fireStore
          .collection('ReceivedOrders')
          .doc(orderId)
          .delete();

      // Update the order status to 'Accepted' in the orderData map
      orderData['orderStatus'] = 'Accepted';

      // Add the order to the AcceptedOrders collection
      await FirebaseFirestore.instance
          .collection('AcceptedOrders')
          .doc(orderId)
          .set(orderData);

      print('Order $orderId accepted successfully.');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Order Accepted');
    } catch (e) {
      print('Error accepting order: $e');
      // Handle any errors here
    }
  }
  Future<void> completeOrder(String orderId) async {
    try {
      // Update order status in the Orders collection
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
        'orderStatus': 'Completed',
      });

      // Remove the order from the AcceptedOrders subcollection
      await FirebaseFirestore.instance.collection('AcceptedOrders').doc(orderId).delete();

      // Show a success message or perform any other action
      print('Order marked as complete and removed from AcceptedOrders successfully.');
    } catch (error) {
      // Handle errors here
      print('Error marking order as complete and removing from AcceptedOrders: $error');
    }
  }


}