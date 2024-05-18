import 'package:flutter/material.dart';
import 'package:pharmasage/View/Vendors/Emailverification.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Controller/AdminController/VendorProfile.dart';
import '../../Controller/Provider/Authprovider.dart';
import '../../Utils/colors.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;
  TextEditingController userNameController=TextEditingController();
  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
            padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.02),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height*0.04, 0),
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
                Center(child: Text('Registration',style: textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w600),)),
                CommonFunctions.commonSpace(height*0.03, 0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: grey,
                          filled: true,
                          hintText: 'Enter Username',
                          prefixIcon: Icon(
                            Icons.person_outline,
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
                            return 'Please enter Username';
                          }
                          if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'No Special Character';
                          }
                          return null;
                        },
                      ),
                      CommonFunctions.commonSpace(height*0.03, 0),
                      TextFormField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: grey,
                          filled: true,
                          hintText: 'Enter FullName',
                          prefixIcon: Icon(
                            Icons.person_pin_rounded,
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
                            return 'Please enter Full Name';
                          }
                          if (value.contains(RegExp(r'\d'))) {
                            return 'No Numbers';
                          }
                          if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'No Special Character';
                          }
                          return null;
                        },
                      ),
                      CommonFunctions.commonSpace(height*0.03, 0),
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
                          if (!value.contains('@')) {
                            return 'Please enter valid email';
                          }
                          if(!value.contains('.com')){
                            return 'Please enter valid email';
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
                          if (!value.contains(RegExp(r'\d'))) {
                            return 'Password must contain a number';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain capital letter';
                          }
                          if (value.length < 8) {
                            return 'Password must be more than 8 characters';
                          }
                          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Password must contain special character';
                          }
                          return null;
                        },
                      ),
                      CommonFunctions.commonSpace(height*0.04, 0),
                      Consumer<AdminProvider>(
                        builder: (context, authProvider, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                              minimumSize: Size(width, height * 0.08),
                            ),
                            onPressed: () async {// Show loading indicator
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                authProvider.updateLoader();
                                UserController.createUser(context: context,userName: userNameController.text,fullName: fullNameController.text, email: emailController.text, password: passwordController.text);
                              }
                              // Hide loading indicator
                            },
                            child: authProvider.loading
                                ? CircularProgressIndicator(color: white)
                                : Text(
                              'Register',
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
