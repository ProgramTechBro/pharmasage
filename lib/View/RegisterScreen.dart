import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';

import '../Utils/colors.dart';
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height;
    final width=MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration Screen',style: textTheme.bodyLarge!.copyWith(color: white),),
          backgroundColor:primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width*0.03,vertical: height*0.02),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.011, 0),
                TextInputField(textTheme,'Enter Username'),
                CommonFunctions.commonSpace(height*0.02, 0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FirstName',style: textTheme.bodyMedium),
                          CommonFunctions.commonSpace(height*0.011, 0),
                          TextInputField(textTheme,'Enter FirstName'),
                        ],
                      ),
                    ),
                    CommonFunctions.commonSpace(0, width*0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LastName',style: textTheme.bodyMedium),
                          CommonFunctions.commonSpace(height*0.011, 0),
                          TextInputField(textTheme,'Enter LastName'),
                        ],
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height*0.02, 0),
                Text('PhoneNumber',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.011, 0),
                TextInputField(textTheme,'Enter PhoneNo.'),
                CommonFunctions.commonSpace(height*0.02, 0),
                Text('Email',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.011, 0),
                TextInputField(textTheme,'Enter Email'),
                CommonFunctions.commonSpace(height*0.02, 0),
                Text('Password',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.011, 0),
                TextInputField(textTheme,'Enter Password'),
                CommonFunctions.commonSpace(height*0.02, 0),
                Text('Confirm Password',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.011, 0),
                TextInputField(textTheme,'Enter Password again'),
                CommonFunctions.commonSpace(height*0.04, 0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      minimumSize: Size(width, height*0.08),
                    ),
                    onPressed:(){
                      CommonFunctions.showSuccessToast(context: context, message: 'Register Sucessfully');

                    },
                    child:Text('Register',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
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
