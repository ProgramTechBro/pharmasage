import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/utils/colors.dart';
import '../Constants/CommonFunctions.dart';
bool goToNewPage=false;
class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height;
    final width=MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:Text('Recover Password', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width*0.06,vertical: height*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFunctions.commonSpace(height*0.02, 0),
              Container(
                height: height*0.25,
                decoration: const BoxDecoration(
                  //sshape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/authentication.png'),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height*0.05, 0),
              Text('Create a new password for your account:',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.04, 0),
              Text('New Password',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.015, 0),
              textInputField(textTheme,'Enter new password'),
              CommonFunctions.commonSpace(height*0.03, 0),
              Text('Confirm New Password',style: textTheme.bodyMedium),
              CommonFunctions.commonSpace(height*0.015, 0),
              textInputField(textTheme,'Enter new password again'),
              CommonFunctions.commonSpace(height*0.05, 0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                    minimumSize: Size(width, height*0.08),
                  ),
                  onPressed:() {
                    CommonFunctions.showSuccessToast(context: context, message: 'Code sent successfully');
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        goToNewPage=true;
                      });
                      if(goToNewPage)
                      {
                        Navigator.push(context, PageTransition(child: const SetPassword(), type: PageTransitionType.rightToLeft));
                      }

                    });

                  },
                  child:Text('Continue',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),

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
