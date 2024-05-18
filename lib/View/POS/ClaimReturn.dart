import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/CommonFunctions.dart';
import '../../Controller/AdminController/POSController.dart';
import '../../Model/Transaction/TransactionDetails.dart';
import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
import 'SerachReturn.dart';
class ReturnPagePOS extends StatefulWidget {
  @override
  State<ReturnPagePOS> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPagePOS> {
  TextEditingController claimReturnController=TextEditingController();
  TransactionModel transactionModel=TransactionModel();
  bool isReturnClaiming=false;
  onPressed()async{
    setState(() {
      isReturnClaiming=true;
    });
    String storeId=await getBranchIdFromSharedPreferences();
    print('Store ID $storeId');
    String invoiceNO=claimReturnController.text;
    print('Invoice No $invoiceNO');
    transactionModel=(await POSController.fetchTransactionById(storeId: storeId, transactionId: invoiceNO))!;
    setState(() {
      isReturnClaiming=false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchReturnResult(transactionModel:transactionModel)));

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0XFD9D9D9),
      body: Center(
        child: Container(
          height:height*0.6,
          width: width*0.6,
          //color: Colors.blue,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: CupertinoColors.systemGrey5,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Color(0XF8FB3B9),
                height: height * 0.08,
                width: width,
                child: Center(
                  child: Text(
                    'Claim Return',
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height*0.1, 0),
              Container(
                height: height*0.3,
                width: width*0.4,
                padding: EdgeInsets.symmetric(horizontal: width*0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invoice Number',style: textTheme.bodyMedium),
                    CommonFunctions.commonSpace(height*0.02, 0),
                    InputTextFieldSeller( controller:claimReturnController,title: 'Enter Invoice Number', textTheme: textTheme,),
                    CommonFunctions.commonSpace(height*0.04, 0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          minimumSize: Size(width*0.15, height * 0.08),
                        ),
                        onPressed: onPressed,
                        child: isReturnClaiming ?CircularProgressIndicator(color: Colors.white,):Text(
                          'Process Return',
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  Future<String> getBranchIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? branchId = prefs.getString('branchId');
    return branchId ?? ''; // Return branchId if not null, otherwise return an empty string
  }
}