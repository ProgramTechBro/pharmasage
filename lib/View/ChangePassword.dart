import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/InputTextFiellds.dart';
UserHandler handler=UserHandler();
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var auth=FirebaseAuth.instance;
  var currentUser=FirebaseAuth.instance.currentUser;
  late TextEditingController emailController=TextEditingController();
  late TextEditingController oldPasswordController=TextEditingController();
  late TextEditingController newPasswordController=TextEditingController();
  bool addStoreBtnPressed = false;
  late String currentRole;
  @override
  void onpressed({required String email, required String oldPassword, required String newPassword}) async {
    setState(() {
      addStoreBtnPressed = true;
    });
    await handler.changePassword(email: email, oldPassword: oldPassword, newPassword: newPassword);
    if(currentRole=='Branch Manager')
      {
       await handler.updateBMPassword(context, newPassword);
      }
    setState(() {
      addStoreBtnPressed = false;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentRole = Provider.of<AdminProvider>(context, listen: false).role;
  }
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:Text('Change Password', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFunctions.commonSpace(height*0.03, 0),
              Text('Change your password:',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.06, 0),
              Text('Email/UserName',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.015, 0),
              InputTextFieldSeller(
                controller: emailController,
                title: 'Enter UserName/Email',
                textTheme: textTheme,
              ),
              CommonFunctions.commonSpace(height*0.03, 0),
              Text('Old Password',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.015, 0),
              InputTextFieldSeller(
                controller: oldPasswordController,
                title: 'Enter old password',
                textTheme: textTheme,
              ),
              CommonFunctions.commonSpace(height*0.03, 0),
              Text('New Password',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.015, 0),
              InputTextFieldSeller(
                controller: newPasswordController,
                title: 'Enter new passord',
                textTheme: textTheme,
              ),
              CommonFunctions.commonSpace(height*0.06, 0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  minimumSize: Size(width, height * 0.08),
                ),
                onPressed: ()async{
                  onpressed(email:emailController.text, oldPassword: oldPasswordController.text, newPassword: newPasswordController.text);
                },
                child: addStoreBtnPressed
                    ? CircularProgressIndicator(color: white)
                    : Text(
                  'Add Store',
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField textInputField(TextTheme textTheme,String text) {
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
