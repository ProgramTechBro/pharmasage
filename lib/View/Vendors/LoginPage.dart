import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/View/Vendors/RegisterPage.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Controller/Provider/Authprovider.dart';
import '../../Utils/colors.dart';
import '../Recoverpassword.dart';

UserController profile=UserController();
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading=false;
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height;
    final width=MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            //height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width*.04,vertical: height*.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height*0.01, 0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset('assets/images/Logo2.png'),
                    ),
                  ),
                ),
                Center(child: Text('Login',style: textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w600),)),
                //Text('Email',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.04, 0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: grey,
                        filled: true,
                        hintText: 'Enter Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey.shade600, // Set the desired color here
                        ),
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
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                      ),
                      CommonFunctions.commonSpace(height*0.03, 0),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: obscureText,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: grey,
                          filled: true,
                          hintText: 'Enter Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey.shade600, // Set the desired color here
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
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
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                           return null;
                        },
                      ),
                      CommonFunctions.commonSpace(height*0.015, 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.push(context, PageTransition(child: const RecoverPassword(), type: PageTransitionType.rightToLeft));
                          }, child: Text('Forget Password',style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),),)
                        ],
                      ),
                  Consumer<AdminProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          minimumSize: Size(width, height * 0.08),
                        ),
                        onPressed: () async {
                         // Show loading indicator

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            authProvider.updateLoader();
                            profile.signIn(context: context, email: emailController.text, password: passwordController.text);
                          }
                        },
                        child: authProvider.loading
                            ? CircularProgressIndicator(color: white)
                            : Text(
                          'Login',
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  ],
                  ),
                ),
                //Text('Password',style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height*0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Not Already Register?',style: textTheme.labelMedium),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    }, child: Text('Register Now',style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),)),
                  ],
                ),
                // CommonFunctions.commonSpace(height*0.03, 0),
                // Row(
                //   children: [
                //      Expanded(
                //       child: Divider(
                //         height: 2,
                //         thickness: 2,
                //         color: grey,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: Text('OR',style: textTheme.bodyMedium!.copyWith(color: Colors.grey),),
                //     ),
                //      Expanded(
                //       child: Divider(
                //         height: 2,
                //         thickness: 2,
                //         color: grey,
                //       ),
                //     ),
                //   ],
                // ),
                // CommonFunctions.commonSpace(height*0.02, 0),
                // Center(
                //   child: RichText(text: TextSpan(children:[
                //     TextSpan(text: 'Login',style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
                //     TextSpan(text: ' as Branch Manager.',style: textTheme.labelMedium),
                //   ])),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
