import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import '../../Model/BranchManager/BranchManager.dart';
import '../../Model/User/vendordetails.dart';
import '../colors.dart';
FirebaseFirestore firestore=FirebaseFirestore.instance;
class MyHeaderDrawer extends StatelessWidget {
  final UserHandler services = UserHandler();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final User? user = services.auth.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: fireStore.collection('Users').doc(user!.email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Placeholder widget while data is loading
        }
        final vendorDetailMap = snapshot.data!.data() as Map<String, dynamic>;
        print(vendorDetailMap);
        final String? role = vendorDetailMap['role'];
        print(role);
        if(role=='Pharmacist' || role=='Vendor')
          {
            final vendorDetail = UserProfile.fromMap(vendorDetailMap);
            return Container(
              color: primaryColor,
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.only(top: height * 0.035),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: vendorDetail.imagesURL != 'NULL'
                            ? NetworkImage(vendorDetail.imagesURL!) as ImageProvider<Object>
                            : const AssetImage('assets/images/farmer.png'),
                      ),
                    ),
                  ),
                  Text(
                    vendorDetail.fullName ?? 'No Data', // Display full name if available
                    style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  Text(
                    vendorDetail.email ?? 'No data', // Display email if available
                    style: textTheme.labelLarge!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          }
        else{
          final bmData = BranchManagerData.fromMap(vendorDetailMap);
          return Container(
            color: primaryColor,
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(top: height * 0.035),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.01),
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: bmData.branchManagerImage != 'NULL'
                          ? NetworkImage(bmData.branchManagerImage!) as ImageProvider<Object>
                          : const AssetImage('assets/images/farmer.png'),
                    ),
                  ),
                ),
                Text(
                  bmData.bMFullName ?? 'No Data', // Display full name if available
                  style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                ),
                Text(
                  bmData.bMUserName ?? 'No data', // Display email if available
                  style: textTheme.labelLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
          );

        }


      },
    );
  }
}
