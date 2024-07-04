import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmasage/Controller/Provider/Employeeprovider.dart';
import 'package:pharmasage/Model/Employee/Employees.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../Provider/Authprovider.dart';
import '../Provider/StoreProvider.dart';
FirebaseAuth auth=FirebaseAuth.instance;
FirebaseStorage storage=FirebaseStorage.instance;
FirebaseFirestore firestore=FirebaseFirestore.instance;
class EmployeeController {
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

  static uploadEmployeeImageToFirebaseStorage({
    required File images,
    required BuildContext context,
    required String imageNAme,
  }) async {


    String imageName = '$imageNAme.jpg';
    Reference ref = storage.ref().child('Employee_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    print('////Image Url is $imageURL');
    Provider.of<EmployeeProvider>(context, listen: false).updateEmployeeImagesURL(
        imagesURLs: imageURL);
  }
  static uploadUpdatedEmployeeImageToFirebaseStorage({
    required File images,
    required BuildContext context,
    required String imageNAme,
  }) async {


    String imageName = '$imageNAme.jpg';
    await deleteImageFromFirebaseStorage(imageName);
    Reference ref = storage.ref().child('Employee_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    print('////Image Url is $imageURL');
    Provider.of<EmployeeProvider>(context, listen: false).updatedUpdatedEmployeeImageURL(
        imagesURLs: imageURL);
  }

  static Future<void> addEmployee({
    required BuildContext context,
    required Employees employees,
  }) async {
    try {
      firestore.collection('Employees')
          .doc(employees.employeeBranchID) // Use authenticated user's email
          .collection('Employee ID') // Subcollection under the user's email
          .doc(employees.employeeID) // Use StoreId as document ID
          .set(employees.toMap());// Set product details as document fields
      log('Data Added');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Employee Added Successful');
      Provider.of<EmployeeProvider>(context,listen: false).emptyEmployeeImages();
    } catch (e) {
      print('idr aya############');
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  static Future<void> deleteEmployee({
    required BuildContext context,
    required String employeeID,
    required String branchID,
  }) async {
    await deleteImageFromFirebaseStorage(employeeID);
    try {
      await FirebaseFirestore.instance
          .collection('Employees')
          .doc(branchID)
          .collection('EmployeeData')
          .doc(employeeID)
          .delete();
      log('Employee Deleted');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Employee Deleted')),
      );
    } catch (e) {
      log('Error deleting employee: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Employee')),
      );
    }
  }
  static Future<void> deleteImageFromFirebaseStorage(String imageName) async {
    String imageNAme = '$imageName.jpg';
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Employee_Images').child(imageNAme);
      await ref.delete();
      print('Image deleted from Firebase Storage: $imageName');
    } catch (e) {
      print('Error deleting image from Firebase Storage: $e');
    }
  }
  Future<void> updateEmployeeData({required BuildContext context,required Employees details})async
  {
    try {
      await FirebaseFirestore.instance
          .collection('Employees')
          .doc(details.employeeBranchID).collection('Employee ID').doc(details.employeeID)
          .update(details.toMap())
          .whenComplete(() {
        log('Data Updated');
        CommonFunctions.showSuccessToast(
            context: context, message: 'Changes Saved');
        Provider.of<EmployeeProvider>(context,listen: false).emptyUpdatedEmployeeImagesURL();
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }

  }
  Future<Map<String, dynamic>> getEmployeeData(String employeeId,String bid) async {
    try {
      // Assuming 'employees' is your collection in Firestore
      print(employeeId);
      print(bid);
      DocumentSnapshot employeeSnapshot =
      await FirebaseFirestore.instance.collection('Employees').doc(employeeId).collection('Employee ID').doc(bid).get();

      if (employeeSnapshot.exists) {
        Map<String, dynamic> employeeData = employeeSnapshot.data() as Map<String, dynamic>;
        print('Here');
        return employeeData;
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      print('Error fetching employee data: $e');
      throw Exception('Failed to fetch employee data');
    }
  }

}