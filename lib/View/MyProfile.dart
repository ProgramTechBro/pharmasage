
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/DataContainer.dart';
import 'package:pharmasage/Utils/widgets/PopMenuProfile.dart';
import 'package:pharmasage/View/BranchManagerPage.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Authprovider.dart';
import '../Controller/Service/Admin/vendorServices.dart';
import '../Model/BranchManager/BranchManager.dart';
import '../Model/User/vendordetails.dart';
import '../Utils/widgets/Textontheline.dart';

final UserHandler services = UserHandler();

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final User? user = services.auth.currentUser;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Profile',
            style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: services.fireStore.collection('Users').doc(user!.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final vendorDetailMap = snapshot.data!.data()! as Map<String, dynamic>;
              final String? role = vendorDetailMap['role'];
              print(role);
              if(role=='Pharmacist' || role=='Vendor')
                {
                  final vendorDetail = UserProfile.fromMap(vendorDetailMap);
                  print('This is ${vendorDetail.imagesURL}');
                  return SingleChildScrollView(
                    child: Container(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopMenuProfile(role: role!,),
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.19,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: vendorDetail.imagesURL != 'NULL'
                                    ? NetworkImage(vendorDetail.imagesURL!) as ImageProvider<Object>
                                    : const AssetImage('assets/images/farmer.png'),
                              ),
                            ),
                          ),
                          Container(
                            height: height,
                            width: width,
                            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.02),
                                Text('Your Information :', style: textTheme.bodyMedium),
                                SizedBox(height: height * 0.04),
                                Text('Username', style: textTheme.labelLarge),
                                SizedBox(height: height * 0.01),
                                DataContainer(icon: Icons.person_outline, title: vendorDetail.userName ?? 'No Data', height: height, width: width, textTheme: textTheme),
                                SizedBox(height: height * 0.02),
                                Text('Full Name', style: textTheme.labelLarge),
                                SizedBox(height: height * 0.01),
                                DataContainer(icon: Icons.person_pin_rounded, title: vendorDetail.fullName ?? 'No Data', height: height, width: width, textTheme: textTheme),
                                SizedBox(height: height * 0.02),
                                Text('Your Email', style: textTheme.labelLarge),
                                SizedBox(height: height * 0.01),
                                DataContainer(icon: Icons.email_rounded, title: vendorDetail.email ?? 'No Data', height: height, width: width, textTheme: textTheme),
                                SizedBox(height: height * 0.02),
                                Text('Contact No.', style: textTheme.labelLarge),
                                SizedBox(height: height * 0.01),
                                DataContainer(icon: Icons.contact_mail, title: vendorDetail.contact ?? 'No Data', height: height, width: width, textTheme: textTheme),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              else{
                final bmData = BranchManagerData.fromMap(vendorDetailMap);
                final String? role = bmData.role;
                return SingleChildScrollView(
                  child: Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopMenuProfile(role: role!,),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.19,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: bmData.branchManagerImage != null && bmData.branchManagerImage != 'NULL'
                                ? DecorationImage(
                              image: NetworkImage(bmData.branchManagerImage??''),
                            )
                                : const DecorationImage(
                              image: AssetImage('assets/images/farmer.png'),
                            ),
                          ),
                        ),
                        Container(
                          height: height,
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.02),
                              Text('Your Information :', style: textTheme.bodyMedium),
                              SizedBox(height: height * 0.04),
                              Text('Username', style: textTheme.labelLarge),
                              SizedBox(height: height * 0.01),
                              DataContainer(icon: Icons.person_outline, title: bmData.bMUserName ?? 'No Data', height: height, width: width, textTheme: textTheme),
                              CommonFunctions.commonSpace(height * 0.02, 0),
                              Text('Full Name', style: textTheme.labelLarge),
                              SizedBox(height: height * 0.01),
                              DataContainer(icon: Icons.person_outline, title: bmData.bMFullName ?? 'No Data', height: height, width: width, textTheme: textTheme),
                              CommonFunctions.commonSpace(height * 0.02, 0),
                              Text('Branch ID', style: textTheme.labelLarge),
                              SizedBox(height: height * 0.01),
                              DataContainer(icon: Icons.person_outline, title: bmData.branchID ?? 'No Data', height: height, width: width, textTheme: textTheme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              }
            }
          },
        ),
      ),
    );
  }
}
