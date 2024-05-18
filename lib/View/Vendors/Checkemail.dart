import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/View/Dashboard.dart';
import 'package:pharmasage/View/StoreDashboard.dart';
import 'package:pharmasage/View/Vendors/Emailverification.dart';
import 'package:pharmasage/View/Vendors/simpleEmail.dart';
import 'package:provider/provider.dart';

import '../VendorDashboard.dart';
FirebaseAuth auth=FirebaseAuth.instance;
UserController profile=UserController();
class CheckEmailVerified extends StatefulWidget {
  final String? email;

  const CheckEmailVerified({Key? key, required this.email}) : super(key: key);

  @override
  State<CheckEmailVerified> createState() => _CheckEmailVerifiedState();
}

class _CheckEmailVerifiedState extends State<CheckEmailVerified> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified=auth.currentUser!.emailVerified;
    if(!isEmailVerified)
    {
       sendVerificationEmail();
    }
    timer=Timer.periodic(Duration(seconds: 3),(_)=>checkEmailVerify(),
    );
  }

  Future<void> sendVerificationEmail()async{
    try{
      final user=auth.currentUser;
      await user!.sendEmailVerification();
    }catch(e)
    {
      CommonFunctions.showWarningToast(context: context, message:'Verify again');
    }

  }
  Future<void> checkEmailVerify()async{
    print('gggggggggggggggg');
    await auth.currentUser!.reload();
    setState(() {
      isEmailVerified=auth.currentUser!.emailVerified;
    });
    if(isEmailVerified)timer!.cancel();
  }
  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      print('yesyesyes');
      if(Provider.of<AdminProvider>(context).role=='Pharmacist')
        {
          print('Yaha ha g');
          return Dashboard();
        }
      else if(Provider.of<AdminProvider>(context).role=='Vendor')
        {
          return VendorDashboard();
        }
      else
        {
          String bid=Provider.of<AdminProvider>(context).Branchid;
          return storeDashboard(branchID: bid);
        }
      //return Dashboard();
    } else {
      //auth.currentUser!.sendEmailVerification();
      return EmailVerificationcomplex(key: UniqueKey(), email: widget.email!);
    }
  }
}
