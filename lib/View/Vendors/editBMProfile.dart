import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/View/BranchManagerPage.dart';

import '../../Constants/CommonFunctions.dart';
import '../../Model/BranchManager/BranchManager.dart';
import '../../Utils/colors.dart';
import '../EditProfile.dart';
class EditBMProfile extends StatefulWidget {
  final String bMUserName;
  const EditBMProfile({super.key,required this.bMUserName});

  @override
  State<EditBMProfile> createState() => _EditBMProfileState();
}

class _EditBMProfileState extends State<EditBMProfile> {
  UserHandler handler=UserHandler();
  late TextEditingController bmUserNameController = TextEditingController();
  late TextEditingController bmFullNameController = TextEditingController();
  late TextEditingController bmRoleController = TextEditingController();
  late TextEditingController bmBranchIDController = TextEditingController();
  String branchImage='';
  String role='';
  String bmPassword='';
  bool isLoading=false;
  bool isBMDataUpdating=false;
  bool check = true;
  Map<String, dynamic> bmDetails={};
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBMDetails();
  }
  fetchBMDetails()async{
    setState(() {
      isLoading=true;
    });
    bmDetails=await handler.getBMData(widget.bMUserName);
    if(check){
      bmRoleController.text=bmDetails['role'];
      bmFullNameController.text=bmDetails['bMFullName'];
      bmUserNameController.text=bmDetails['bMUserName'];
      bmBranchIDController.text=bmDetails['branchID'];
      branchImage=bmDetails['branchManagerImage'];
      role=bmDetails['role'];
      bmPassword=bmDetails['bMPassword'];
      check=false;
    }
    setState(() {
      isLoading=false;
    });

  }
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Edit BMProfile', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(color: primaryColor,),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit BMProfile', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: height * 0.15,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover, // Adjust how the image fits within the circle
                      image: bmDetails['branchManagerImage'] != null
                          ? NetworkImage(bmDetails['branchManagerImage']!)
                          : AssetImage('assets/images/farmer.png') as ImageProvider, // Cast AssetImage to ImageProvider
                    ),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.04, 0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        EditTextField(Controller: bmRoleController, textTheme: textTheme, hintext: 'Enter Role', icon: Icons.person_pin),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: bmFullNameController, textTheme: textTheme, hintext: 'Enter FullName', icon: Icons.person_pin_rounded),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: bmUserNameController, textTheme: textTheme, hintext: 'Enter BMUserName', icon: Icons.email_outlined),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: bmBranchIDController, textTheme: textTheme, hintext: 'Enter BranchID', icon: Icons.store),
                        CommonFunctions.commonSpace(height * 0.05, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                  side: BorderSide(color:primaryColor),
                                  minimumSize: Size(width, height * 0.08),
                                ),
                                onPressed: () async {
                                  CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                                  await Future.delayed(const Duration(seconds: 3));
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Discard',
                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color:primaryColor),
                                ),
                              ),
                            ),
                            CommonFunctions.commonSpace(0, width * 0.04),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                  minimumSize: Size(width, height * 0.08),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isBMDataUpdating=true;
                                  });
                                  BranchManagerData bmData = BranchManagerData(
                                    branchID: bmBranchIDController.text.isNotEmpty?bmBranchIDController.text:bmDetails['branchID'],
                                    bMFullName: bmFullNameController.text.isNotEmpty?bmFullNameController.text:bmDetails['bMFullName'],
                                    bMUserName: bmUserNameController.text.isNotEmpty?bmUserNameController.text:bmDetails['bMUserName'],
                                    bMPassword: bmPassword,
                                    branchManagerImage: branchImage,
                                  );
                                  await handler.updateBMData(context: context, details:bmData);
                                  setState(() {
                                    isBMDataUpdating=true;
                                  });
                                },
                                child: isBMDataUpdating
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  'Save',
                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
