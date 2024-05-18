import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/View/Vendors/LoginPage.dart';
import 'package:provider/provider.dart';

import '../../Constants/CommonFunctions.dart';
import '../../Utils/colors.dart';
import '../Dashboard.dart';
import '../VendorDashboard.dart';
FirebaseAuth auth=FirebaseAuth.instance;
class ForgetPassword extends StatefulWidget {
  final String email;

  ForgetPassword({required Key key, required this.email}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // bool isResendButtonEnabled = false;
  // int secondsRemaining = 30;
  // String timerText = '30';
  // Timer? timer;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   startTimer();
  //   checkEmailVerificationStatusAfterDelay();
  // }
  //
  // @override
  // void dispose() {
  //   timer?.cancel(); // Cancel the timer to prevent memory leaks
  //   super.dispose();
  // }
  //
  // void startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
  //     if (secondsRemaining > 0) {
  //       setState(() {
  //         secondsRemaining--;
  //         timerText = secondsRemaining.toString();
  //       });
  //     } else {
  //       t.cancel();
  //       setState(() {
  //         isResendButtonEnabled = true;
  //       });
  //     }
  //   });
  // }
  // void restartTimer() {
  //   setState(() {
  //     secondsRemaining = 30;
  //     timerText = '30';
  //     isResendButtonEnabled = false;
  //   });
  //   startTimer();
  // }
  //
  //
  // void checkEmailVerificationStatusAfterDelay() {
  //   Future.delayed(Duration(seconds: 3), () async {
  //     bool isVerified = await isEmailVerified();
  //     if (isVerified) {
  //       // Move to the dashboard screen
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => VendorDashboard()),
  //       );
  //     } else {
  //       // If not verified, enable the resend button and call itself after 3 seconds
  //       setState(() {
  //         isResendButtonEnabled = true;
  //       });
  //
  //       // Call itself after 3 seconds
  //       checkEmailVerificationStatusAfterDelay();
  //     }
  //   });
  // }
  //
  //
  // Future<bool> isEmailVerified() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.reload();
  //     return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  //   } catch (e) {
  //     print('Error checking email verification status: $e');
  //     return false;
  //   }
  // }
  //
  // void resendVerificationEmail() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  //     // Reset the timer and disable the resend button
  //     restartTimer();
  //   } catch (e) {
  //     print('Error resending verification email: $e');
  //     // Handle the error as needed
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonFunctions.commonSpace(height * 0.02, 0),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 100,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('assets/images/fp2.png'),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.02, 0),
              Center(
                child: Text(
                  'Password Resent Email Sent',
                  style: textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.02, 0),
              Center(
                child: Text(
                  widget.email,
                  style: textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600,fontWeight: FontWeight.bold),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.03, 0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Center(
                  child: Text(
                    'Your Account is Our Priority!.We have Send You a Secure Link to Safely Change Your Password and Keep Your Account Safe.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall!.copyWith(color: Colors.grey.shade600,),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.04, 0),
              Center(
                child: ElevatedButton(
                  onPressed: ()
                  {
                    auth.sendPasswordResetEmail(email: widget.email);
                    CommonFunctions.showSuccessToast(context: context, message: 'Email Sent Again');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size(width * 0.95, height * 0.08),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RESEND',
                        style: textTheme.bodySmall!.copyWith(color: white, fontWeight: FontWeight.w600),
                      ),
                      CommonFunctions.commonSpace(0, width * 0.02),
                      Icon(Icons.email_rounded, size: 25, color: white),
                    ],
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.02, 0),
              Center(
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, PageTransition(child: const LoginPage(), type: PageTransitionType.rightToLeft));
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color:primaryColor),
                    backgroundColor: white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size(width * 0.95, height * 0.08),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DONE',
                        style: textTheme.bodySmall!.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                      CommonFunctions.commonSpace(0, width * 0.02),
                      Icon(Icons.check_circle, size: 25, color: primaryColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
