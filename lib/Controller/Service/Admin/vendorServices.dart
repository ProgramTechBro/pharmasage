import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/Model/BranchManager/BranchManager.dart';
import 'package:pharmasage/View/Vendors/Emailverification.dart';
import 'package:pharmasage/View/Vendors/Foegetpassword.dart';
import 'package:provider/provider.dart';
import '../../../Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import '../../../Model/User/vendordetails.dart';
import '../../../View/Dashboard.dart';
import 'package:http/http.dart' as http;
UserController profile=UserController();
class UserHandler {
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser=FirebaseAuth.instance.currentUser;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImageToFirebaseStorage({
    required File image,
    required BuildContext context,
  }) async {
    try {
      String sellerUID = auth.currentUser!.email!;
      String imageName = '$sellerUID';
      Reference ref = storage.ref().child('vendor_Images').child(imageName);
      await ref.putFile(image);
      String imageURL = await ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Handle the error as needed, return an empty string, or throw an exception
    }
  }
  Future CreateUserData({required BuildContext context, required UserProfile details,}) async {
    try {
      await fireStore
          .collection('Users')
          .doc(details.email)
          .set(details.toMap())
          .whenComplete(() async {
        log('Vendor Data Added');
        Provider.of<AdminProvider>(context,listen: false).updateLoader();
        CommonFunctions.showSuccessToast(context: context, message: 'Registered Successfully');
        await Future.delayed(const Duration(seconds: 2));
        auth.currentUser!.sendEmailVerification();
        Navigator.pushReplacement(context, PageTransition(child:  EmailVerificationScreen(email:auth.currentUser!.email!,key:UniqueKey()), type: PageTransitionType.rightToLeft));

      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  Future createNewBM({required BuildContext context, required BranchManagerData details,}) async {
    try {
      await fireStore
          .collection('Users')
          .doc(details.bMUserName)
          .set(details.toMap())
          .whenComplete(() async {
        log('BM Data Added');
        CommonFunctions.showSuccessToast(context: context, message: 'BM added Successfully');

      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
  Future<void> updateUserData({required BuildContext context,required UserProfile details})async
  {
    try {
      await fireStore
          .collection('Users')
          .doc(details.email)
          .update(details.toMap())
          .whenComplete(() {
        log('Data Updated');
        CommonFunctions.showSuccessToast(
            context: context, message: 'Changes Saved');
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }

  }
  Future<void> updateBMData({required BuildContext context,required BranchManagerData details})async
  {
    try {
      await fireStore
          .collection('Users')
          .doc(details.bMUserName)
          .update(details.toMap())
          .whenComplete(() {
        log('Data Updated');
        CommonFunctions.showSuccessToast(
            context: context, message: 'Changes Saved');
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }

  }
  Future<void> updateRoleForUser(BuildContext context,String newRoleValue) async {
    Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
    try {
      // Get a reference to the document you want to update
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.email);

      // Update the 'role' field with the new value
      Map<String, dynamic> data = {'role': newRoleValue};

      // Perform the update operation
      await userDocRef.update(data);
      print("Role updated successfully");
      Provider.of<AdminProvider>(context,listen: false).updateRole(newRoleValue);
      Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
    } catch (error) {
      print("Failed to update role: $error");
      // You can throw the error here to handle it in the calling code if needed
      throw error;
    }
  }
  Future<void> forgetPassword(BuildContext context,String email)async{
    auth.sendPasswordResetEmail(email: email).then((value) async {
      CommonFunctions.showSuccessToast(context: context, message: 'Email Sent');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(context, PageTransition(child: ForgetPassword(key: UniqueKey(), email: email), type: PageTransitionType.rightToLeft));
    });
  }
  Future<void> changePassword({email,oldPassword,newPassword})async
  {
    var cred = EmailAuthProvider.credential(email: email, password: oldPassword);
    try {
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.updatePassword(newPassword);
    } catch (error) {
      print(error.toString());
    }
  }
   Future<void> updateBMPassword(BuildContext context,String newPassword) async {
    Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
    try {
      // Get a reference to the document you want to update
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.email);

      // Update the 'role' field with the new value
      Map<String, dynamic> data = {'bMPassword': newPassword};

      // Perform the update operation
      await userDocRef.update(data);
      print("Role updated successfully");
      //Provider.of<AdminProvider>(context,listen: false).updateRole(newRoleValue);
      //Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
      CommonFunctions.showSuccessToast(context: context, message: 'Password Changed');
    } catch (error) {
      print("Failed to update role: $error");
      // You can throw the error here to handle it in the calling code if needed
      throw error;
    }
  }
  Future<Map<String, dynamic>> getBMData(String username) async {
    try {
      DocumentSnapshot employeeSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(username).get();

      if (employeeSnapshot.exists) {
        Map<String, dynamic> bmData = employeeSnapshot.data() as Map<String, dynamic>;
        return bmData;
      } else {
        throw Exception('Branch Manager Not Found');
      }
    } catch (e) {
      print('Error fetching BranchManager data: $e');
      throw Exception('Failed to fetch BranchManager data');
    }
  }

  Future<void> deleteBMUserDocument(BuildContext context,String username) async {
    try{
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(username)
          .delete();
      print('Branch Manager deleted successfully');
      CommonFunctions.showSuccessToast(context: context, message: 'BM Deleted');
    }catch(e){
      print('Error deleting Branch Manager: $e');
    }
  }

  // Future<void> deleteBranchManager(String email) async {
  //   try {
  //     // Delete the user from Firebase Authentication
  //     await deleteUserFromAuth(email);
  //
  //     // Delete the user document from Firestore
  //     await deleteBMUserDocument(email);
  //
  //     print('Branch Manager deleted successfully');
  //   } catch (e) {
  //     print('Error deleting Branch Manager: $e');
  //   }
  // }
  // Future<void> deleteUserFromAuth(String email) async {
  //   final url = Uri.parse('https://your-backend-server.com/deleteUser'); // Replace with your server URL
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseBody = jsonDecode(response.body);
  //     if (responseBody['success']) {
  //       print('User deleted successfully from Firebase Authentication');
  //     } else {
  //       print('Error: ${responseBody['message']}');
  //     }
  //   } else {
  //     print('Server error: ${response.statusCode}');
  //   }
  // }
}
