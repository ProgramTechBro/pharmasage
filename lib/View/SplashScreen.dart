import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/View/Vendors/checkrole.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Authprovider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Provider.of<AdminProvider>(context, listen: false).changeStatus();
      Navigator.pushReplacement(context, PageTransition(child: HomeScreen(), type: PageTransitionType.rightToLeft));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height * 0.08, 0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 120,
                    child: Image.asset(
                      'assets/images/Logo2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height * 0.08, 0),
                if (Provider.of<AdminProvider>(context).isReady)
                  Center(child: CircularProgressIndicator(color: primaryColor)),
                CommonFunctions.commonSpace(height * 0.18, 0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: Image.asset(
                      'assets/images/cust.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height * 0.02, 0),
                Center(
                  child: Text(
                    'Powered By C.U.S.T',
                    style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
