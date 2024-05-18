import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/POS/MainPOs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
class POSSplash extends StatefulWidget {
  const POSSplash({super.key});

  @override
  State<POSSplash> createState() => _POSSplashState();
}

class _POSSplashState extends State<POSSplash> {
  TextEditingController branchIDController=TextEditingController();
  bool POSInitializing=false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
     appBar: PreferredSize(
       preferredSize: Size.fromHeight(height * 0.12),
       child: Center(
         child: Container(
           color: Colors.white,
           child: Center(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset('assets/images/B1.png'),
                 //CommonFunctions.commonSpace(0, width * 0.002),
                 Image.asset('assets/images/B2.png'),
               ],
             ),
           ),
         ),
       ),
     ),
        body: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: width*0.5,
                  //color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Point Of Sale',style: textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w900,color: primaryColor,fontSize: 50),),
                      CommonFunctions.commonSpace(height*0.05, 0),
                      //Text('Sale',style: textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w900,color: primaryColor,fontSize: 50),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/tick.png',height: height*0.1,width: width*0.1,),
                              Text('Billing Management',style: textTheme.displayLarge,),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/tick.png',height: height*0.1,width: width*0.1,),
                              Text('Sale Oversight',style: textTheme.displayLarge,),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/tick.png',height: height*0.1,width: width*0.1,),
                              Text('Inventory Control',style: textTheme.displayLarge,),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/tick.png',height: height*0.1,width: width*0.1,),
                              Text('Returns Management',style: textTheme.displayLarge,),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: width*0.5,
                  //color:Colors.blue,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.02),
                      height: height*0.5,
                      width: width*0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 4, // Blur radius
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],// Add color to the container
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonFunctions.commonSpace(height*0.05, 0),
                          Text('Welcome',style: textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),),
                          CommonFunctions.commonSpace(height*0.05, 0),
                          Text('Enter Branch ID to Continue',style: textTheme.displaySmall!,),
                          CommonFunctions.commonSpace(height*0.03,0 ),
                          Text('Branch ID',style: textTheme.bodyMedium),
                          CommonFunctions.commonSpace(height*0.03, 0),
                          InputTextFieldSeller( controller:branchIDController,title: 'Branch ID', textTheme: textTheme),
                          CommonFunctions.commonSpace(height*0.03,0 ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                minimumSize: Size(width*0.1, height * 0.08),
                              ),
                              onPressed: (){
                                saveBranchIdAndNavigate(context,branchIDController.text);
                              },
                              child: POSInitializing
                                  ? CircularProgressIndicator(color: white)
                                  : Text(
                                'Submit',
                                style: textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void saveBranchIdAndNavigate(BuildContext context,String branchID) async {
    setState(() {
      POSInitializing = true;
    });

    // Here, you can replace 'yourBranchId' with the actual branch ID you want to save
    String branchId = branchID;

    // Save branch ID to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('branchId', branchId);

    // After saving, navigate to the next screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPos()), // Replace 'NextScreen()' with your actual next screen
    );

    setState(() {
      POSInitializing = false;
    });
  }
}