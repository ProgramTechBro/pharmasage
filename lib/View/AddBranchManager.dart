import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Model/BranchManager/BranchManager.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/InputTextFiellds.dart';
import '../Constants/CommonFunctions.dart';

class AddBranchManager extends StatefulWidget {
  const AddBranchManager({Key? key}) : super(key: key);

  @override
  State<AddBranchManager> createState() => _AddBranchManagerState();
}

class _AddBranchManagerState extends State<AddBranchManager> {
  TextEditingController bmUserNameController = TextEditingController();
  TextEditingController bmFullNameController = TextEditingController();
  TextEditingController branchIDController = TextEditingController();
  TextEditingController bmPasswordController = TextEditingController();
  bool addStoreBtnPressed = false;
  final _formKey = GlobalKey<FormState>();

  void onPressed() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      setState(() {
        addStoreBtnPressed = true;
      });

      BranchManagerData bmDetails = BranchManagerData(
        branchManagerImage: 'NULL',
        bMUserName: bmUserNameController.text,
        bMFullName: bmFullNameController.text,
        branchID: branchIDController.text,
        bMPassword: bmPasswordController.text,
        role: 'Branch Manager',
      );

      await UserController.createBranchManager(
        context: context,
        data: bmDetails,
      );

      bmUserNameController.clear();
      bmFullNameController.clear();
      branchIDController.clear();
      bmPasswordController.clear();

      setState(() {
        addStoreBtnPressed = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Add Branch Manager',
            style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Text(
                    'Add branch Manager Details here:',
                    style: textTheme.labelLarge,
                  ),
                  CommonFunctions.commonSpace(height * 0.04, 0),
                  Text('User Name', style: textTheme.bodySmall),
                  CommonFunctions.commonSpace(height * 0.015, 0),
                  InputTextFieldSeller(
                    controller: bmUserNameController,
                    title: 'Enter User Name',
                    textTheme: textTheme,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter UserName';
                        }
                        return null;
                      },
                  ),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Text('Full Name', style: textTheme.bodySmall),
                  CommonFunctions.commonSpace(height * 0.015, 0),
                  InputTextFieldSeller(
                    controller: bmFullNameController,
                    title: 'Enter Full Name',
                    textTheme: textTheme,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter FullName';
                      }
                      return null;
                    },
                  ),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Text('Branch ID', style: textTheme.bodySmall),
                  CommonFunctions.commonSpace(height * 0.015, 0),
                  InputTextFieldSeller(
                    controller: branchIDController,
                    title: 'Enter Branch ID',
                    textTheme: textTheme,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter BranchID';
                      }
                      return null;
                    },
                  ),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Text('Password', style: textTheme.bodySmall),
                  CommonFunctions.commonSpace(height * 0.015, 0),
                  InputTextFieldSeller(
                    controller: bmPasswordController,
                    title: 'Enter Password',
                    textTheme: textTheme,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  CommonFunctions.commonSpace(height * 0.04, 0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      minimumSize: Size(width, height * 0.08),
                    ),
                    onPressed: onPressed,
                    child: addStoreBtnPressed
                        ? CircularProgressIndicator(color: white)
                        : Text(
                      'Add BM',
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
        ),
      ),
    );
  }

}
