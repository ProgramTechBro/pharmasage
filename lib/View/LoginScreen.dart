import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/View/Dashboard.dart';
import 'package:pharmasage/View/Recoverpassword.dart';
import 'package:pharmasage/View/RegisterScreen.dart';
import '../Constants/CommonFunctions.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height;
    final width=MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
              padding: EdgeInsets.symmetric(horizontal: width*.06,vertical: height*.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height*0.02, 0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 90,
                    child: Image.asset('assets/images/Logo2.png',fit: BoxFit.cover,),
                  ),
                ),
                Center(child: Text('Login',style: textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w600),)),
                Text('Email',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.015, 0),
                TextInputField(textTheme,'Enter Email'),
                CommonFunctions.commonSpace(height*0.02, 0),
                Text('Password',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.015, 0),
                TextInputField(textTheme, 'Enter Password'),
                CommonFunctions.commonSpace(height*0.015, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.push(context, PageTransition(child: const RecoverPassword(), type: PageTransitionType.rightToLeft));
                    }, child: Text('Forget Password',style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),),)
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      minimumSize: Size(width, height*0.08),
                    ),
                    onPressed: ()  async{
                      CommonFunctions.showSuccessToast(context: context, message: 'Login Successfully');
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pushReplacement(context, PageTransition(child:  Dashboard(), type: PageTransitionType.rightToLeft));
                    },
                    child:Text('Login',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
                CommonFunctions.commonSpace(height*0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Not Already Register?',style: textTheme.labelMedium),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    }, child: Text('Register Now',style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),))
                  ],
                ),
                CommonFunctions.commonSpace(height*0.03, 0),
                 Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR',style: textTheme.bodyMedium!.copyWith(color: Colors.grey),),
                    ),
                    const Expanded(
                      child: Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height*0.02, 0),
                Center(
                  child: RichText(text: TextSpan(children:[
                    TextSpan(text: 'Login',style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' as Branch Manager.',style: textTheme.labelMedium),
                  ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField TextInputField(TextTheme textTheme,String text) {
    return TextFormField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration:  InputDecoration(
                  fillColor: grey,
                  filled: true,
                  hintText: text,
                  hintStyle: textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  disabledBorder:const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              );
  }

}
