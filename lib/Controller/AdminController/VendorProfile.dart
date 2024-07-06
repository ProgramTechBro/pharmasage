import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Controller/Provider/ProductProvider.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/Model/BranchManager/BranchManager.dart';
import 'package:pharmasage/View/VendorDashboard.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Model/User/vendordetails.dart';
import '../../View/Dashboard.dart';
import '../../View/StoreDashboard.dart';
import '../Provider/Authprovider.dart';
import 'ProductController.dart';
FirebaseAuth auth=FirebaseAuth.instance;
UserHandler services=UserHandler();
UserProfile detail=UserProfile();
String Branchid='';
class UserController{
  // Future<void> signIn({required BuildContext context,required String email,required String password})async{
  //   try{
  //     auth.signInWithEmailAndPassword(email: email, password: password).then((user) async {
  //       if (user.user != null) {
  //         print('SignInSuccessfully');
  //         //detail=await getvendorinfo(email);
  //         Provider.of<AdminProvider>(context,listen: false).updateLoader();
  //         CommonFunctions.showSuccessToast(context: context, message: 'Login Successfully');
  //         await Future.delayed(const Duration(seconds: 2));
  //         Navigator.pushReplacement(context, PageTransition(child:  VendorDashboard(), type: PageTransitionType.rightToLeft));
  //       } else{
  //         CommonFunctions.showErrorToast(context: context, message: 'Login Failed');
  //       }
  //     });
  //   }on FirebaseAuthException catch (e) {
  //     String errorMessage;
  //     if (e.code == 'user-not-found') {
  //       errorMessage = 'No user found';
  //     } else if (e.code == 'wrong-password') {
  //       errorMessage = 'Wrong password';
  //     } else {
  //       errorMessage = 'Error occurred';
  //     }
  //     CommonFunctions.showErrorToast(context: context, message: errorMessage);
  //   }
  //   catch(e)
  //   {
  //     log(e.toString());
  //   }
  // }
  Future<void> signIn({required BuildContext context, required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          //await Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
          print('SignInSuccessfully');
          Provider.of<AdminProvider>(context, listen: false).updateLoader();
          CommonFunctions.showSuccessToast(context: context, message: 'Login Successfully');
          print('By');
          await Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
          print('ye chal gaya');
          final role=Provider.of<AdminProvider>(context,listen: false).role;
          if(role=='Pharmacist')
            {
              //print('chalo g pharmacist');
              Navigator.pushReplacement(context, PageTransition(child: Dashboard(), type: PageTransitionType.rightToLeft));
            }
          else if(role=='Vendor')
            {
              //print('chalo g Vendor');
              Navigator.pushReplacement(context, PageTransition(child: VendorDashboard(), type: PageTransitionType.rightToLeft));
            }
          else{
            //print('branch manager');
            Branchid=Provider.of<AdminProvider>(context,listen: false).bm.branchID!;
            print(Branchid);
            Provider.of<AdminProvider>(context,listen: false).updateCurrentBranch(Branchid);
            Navigator.pushReplacement(context, PageTransition(child: storeDashboard(branchID:Branchid,), type: PageTransitionType.rightToLeft));
          }
        } else {
          CommonFunctions.showErrorToast(context: context, message: 'Login Failed');
        }
      }).catchError((e) {
        print("Error: $e");
        String errorMessage;
        if (e is FirebaseAuthException) {
          print(e.code);
          if (e.code == 'invalid-credential') {
            errorMessage = 'Invalid Credential';
            //CommonFunctions.showErrorToast(context: context, message: errorMessage);
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password';
            CommonFunctions.showErrorToast(context: context, message: errorMessage);
          } else {
            print('123');
            errorMessage = 'Error occurred';
            CommonFunctions.showErrorToast(context: context, message: errorMessage);
          }
        } else {
          print('234 $e');
          errorMessage = 'Error occurred';
        }
        CommonFunctions.showErrorToast(context: context, message: errorMessage);
        Provider.of<AdminProvider>(context, listen: false).updateLoader();
      });
    } catch (e) {
      print('Here');
      log('this is error ${e.toString()}');
      CommonFunctions.showErrorToast(context: context, message: 'Error occurred');
      Provider.of<AdminProvider>(context, listen: false).updateLoader();
    }
  }

  static createUser({required BuildContext context,required String userName,required String fullName,required String email,required String password})async
  {
    try{
      UserCredential user=await auth.createUserWithEmailAndPassword(email: email, password: password);
      if(user.user!=null)
        {
         log('signup successfully');
         //String Role=Provider.of<AdminProvider>(context,listen: false).role;
         UserProfile vendorDetail = UserProfile(
           imagesURL: 'NULL',
           fullName: fullName,
           userName: userName,
           contact: '03XXXXXXXXX',
           email: email,
           role:'role',
           //password: password,
         );
        await services.CreateUserData(context:context,details:vendorDetail );
        }
    }catch(e)
    {
      log(e.toString());
    }
  }
  updateUserDetails(BuildContext context,UserProfile details)async
  {
    await services.updateUserData(context: context, details: details);
  }
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

  static uploadVendorImageToFirebaseStorage({
    required File images,
    required BuildContext context,
    required imageNAme,
  }) async {
    String sellerUID = auth.currentUser!.email!;
    Uuid uuid = const Uuid();
    String imageName = '$imageNAme.jpg';
    await deleteImageFromFirebaseStorage(imageName);
    Reference ref = storage.ref().child('Vendor_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    Provider.of<AdminProvider>(context, listen: false).updateVendorImagesURL(
        imagesURLs: imageURL);
  }
  static uploadBMImageToFirebaseStorage({
    required File images,
    required BuildContext context,
    required imageNAme,
  }) async {
    String sellerUID = auth.currentUser!.email!;
    Uuid uuid = const Uuid();

    String imageName = '$imageNAme.jpg';
    await deleteImageFromFirebaseStorage(imageName);
    Reference ref = storage.ref().child('Vendor_Images').child(imageName);
    await ref.putFile(File(images.path));
    String imageURL = await ref.getDownloadURL();
    Provider.of<AdminProvider>(context, listen: false).updateBMImagesURL(
        imagesURLs: imageURL);
  }
   static Future<void> deleteImageFromFirebaseStorage(String imageName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Vendor_Images').child(imageName);
      await ref.delete();
      print('Image deleted from Firebase Storage: $imageName');
    } catch (e) {
      print('Error deleting image from Firebase Storage: $e');
    }
  }

  static createBranchManager({required BuildContext context,required BranchManagerData data})async
  {

    try{
      final uid = await auth.currentUser!.uid;
      final email = await auth.currentUser!.email;
      UserCredential user=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.bMUserName!, password: data.bMPassword!);
      if(user.user!=null)
      {
        log('signup successfully');
        await FirebaseAuth.instance.signOut();
        //String Role=Provider.of<AdminProvider>(context,listen: false).role;
        await services.createNewBM(context: context, details: data);
      }
      //await auth.signInWithEmailAndPassword(email: email!  , password: uid);
    }catch(e)
    {
      log(e.toString());
    }
  }
}