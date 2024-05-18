import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';

import '../../Constants/CommonFunctions.dart';

class MedicalStoreServices{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> updateMedicalStoreData({required BuildContext context,required  MedicalStore details})async
  {
    try {
      await fireStore
      .collection('Medical Stores')
          .doc(auth.currentUser!.email) // Use authenticated user's email
          .collection('StoreID') // Subcollection under the user's email
          .doc(details.branchID)
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
}