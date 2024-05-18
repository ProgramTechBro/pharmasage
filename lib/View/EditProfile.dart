import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/VendorProfile.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/Model/BranchManager/BranchManager.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:provider/provider.dart';

import '../Constants/CommonFunctions.dart';
import '../Model/User/vendordetails.dart';

UserHandler services = UserHandler();
FirebaseAuth auth = FirebaseAuth.instance;

class EditProfile extends StatefulWidget {
  final String role;

  const EditProfile({Key? key, required this.role}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserProfile vendorDetail = UserProfile();
  BranchManagerData bmDetail = BranchManagerData();
  late TextEditingController userNameController = TextEditingController();
  late TextEditingController fullNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController contactController = TextEditingController();
  late TextEditingController branchIDController = TextEditingController();
  String? newImage = '';
  bool check = true;
  String currentRole = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    // Get the current user's role from the provider
    final String role = Provider.of<AdminProvider>(context).role;

    // Check the role and show content accordingly
    if (role == 'Pharmacist' || role == 'Vendor') {
      vendorDetail = Provider.of<AdminProvider>(context).vendorDetail;
      currentRole=vendorDetail.role!;
      if (check) {
        userNameController.text = vendorDetail.userName!;
        fullNameController.text = vendorDetail.fullName!;
        emailController.text = vendorDetail.email!;
        contactController.text = vendorDetail.contact!;
        check = false;
      }
    } else {
      bmDetail = Provider.of<AdminProvider>(context).bm;
      if (check) {
        userNameController.text = bmDetail.bMUserName!;
        fullNameController.text = bmDetail.bMFullName!;
        branchIDController.text = bmDetail.branchID!;
        check = false;
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Edit Profile', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show content based on role
                if (role == 'Pharmacist' || role == 'Vendor') ...[
                  Center(
                    child: Consumer<AdminProvider>(
                      builder: (context, profileImageProvider, child) {
                        return Stack(
                          children: [
                            Container(
                              height: height * 0.15,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: profileImageProvider.vendorImage != null
                                      ? FileImage(File(profileImageProvider.vendorImage!.path!))
                                      : vendorDetail.imagesURL != null && vendorDetail.imagesURL != "NULL"
                                      ? NetworkImage(vendorDetail.imagesURL!) as ImageProvider<Object>
                                      : const AssetImage('assets/images/farmer.png'),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: height * 0.09,
                                width: width * 0.10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(width: width * 0.003, color: Colors.grey),
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () async {
                                      await Provider.of<AdminProvider>(context, listen: false).fetchVendorImagesFromGallery(context: context);
                                    },
                                    icon: Icon(Icons.camera_alt, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  CommonFunctions.commonSpace(height * 0.04, 0),
                  Text('Your Information :', style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            EditTextField(Controller: userNameController, textTheme: textTheme, hintext: 'Enter UserName', icon: Icons.person_outline),
                            CommonFunctions.commonSpace(height * 0.03, 0),
                            EditTextField(Controller: fullNameController, textTheme: textTheme, hintext: 'Enter FullName', icon: Icons.person_pin_rounded),
                            CommonFunctions.commonSpace(height * 0.03, 0),
                            EditTextField(Controller: emailController, textTheme: textTheme, hintext: 'Enter Email', icon: Icons.email_outlined),
                            CommonFunctions.commonSpace(height * 0.03, 0),
                            EditTextField(Controller: contactController, textTheme: textTheme, hintext: 'Enter Contact', icon: Icons.contact_mail),
                            CommonFunctions.commonSpace(height * 0.06, 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                      side: BorderSide(color: primaryColor),
                                      minimumSize: Size(width, height * 0.08),
                                    ),
                                    onPressed: () async {
                                      print('Press');
                                      CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                                      await Future.delayed(const Duration(seconds: 3));
                                      Provider.of<AdminProvider>(context, listen: false).removeVendorImage();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Discard',
                                      style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
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
                                      print('Chalo g');
                                      Provider.of<AdminProvider>(context, listen: false).setSavingStatus();
                                      String? name = auth.currentUser!.email;
                                      if(Provider.of<AdminProvider>(context, listen: false).vendorImage!=null)
                                        {
                                          final productImage = Provider.of<AdminProvider>(context, listen: false).vendorImage;
                                          await UserController.uploadVendorImageToFirebaseStorage(images: productImage!, context: context, imageNAme: name);
                                          newImage = Provider.of<AdminProvider>(context, listen: false).vendorImageUrL;
                                        }
                                      else
                                        {
                                          newImage=Provider.of<AdminProvider>(context, listen: false).vendorDetail.imagesURL;
                                        }
                                      String setRole=currentRole=='Pharmacist'?'Pharmacist':'Vendor';
                                      UserProfile vendorDetail = UserProfile(
                                        imagesURL: newImage ,
                                        userName: userNameController.text.isNotEmpty ? userNameController.text : Provider.of<AdminProvider>(context, listen: false).vendorDetail.userName!,
                                        fullName: fullNameController.text.isNotEmpty ? fullNameController.text : Provider.of<AdminProvider>(context, listen: false).vendorDetail.fullName!,
                                        email: services.auth.currentUser!.email,
                                        contact: contactController.text.isNotEmpty ? contactController.text : Provider.of<AdminProvider>(context, listen: false).vendorDetail.contact!,
                                        role: setRole,
                                      );
                                      await services.updateUserData(context: context, details: vendorDetail);
                                      Provider.of<AdminProvider>(context, listen: false).loadUserDataIntoMemory();
                                      Provider.of<AdminProvider>(context, listen: false).setSavingStatus();
                                      setState(() {});
                                    },
                                    child: Provider.of<AdminProvider>(context).isSaving
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
                if (role != 'Pharmacist' && role != 'Vendor') ...[
                  Center(
                    child: Consumer<AdminProvider>(
                      builder: (context, profileImageProvider, child) {
                        return Stack(
                          children: [
                            Container(
                              height: height * 0.15,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: profileImageProvider.branchManagerProfileImage != null
                                      ? FileImage(File(profileImageProvider.branchManagerProfileImage!.path!))
                                      : bmDetail.branchManagerImage != null && bmDetail.branchManagerImage != "NULL"
                                      ? NetworkImage(bmDetail.branchManagerImage!) as ImageProvider<Object>
                                      : const AssetImage('assets/images/farmer.png'),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: height * 0.09,
                                width: width * 0.10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(width: width * 0.003, color: Colors.grey),
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () async {
                                      await Provider.of<AdminProvider>(context, listen: false).fetchBMImagesFromGallery(context: context);
                                    },
                                    icon: Icon(Icons.camera_alt, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  CommonFunctions.commonSpace(height * 0.04, 0),
                  Text('Your Information :', style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EditTextField(Controller: userNameController, textTheme: textTheme, hintext: 'Enter UserName', icon: Icons.person_outline),
                        CommonFunctions.commonSpace(height * 0.02, 0),
                        EditTextField(Controller: fullNameController, textTheme: textTheme, hintext: 'Enter fullName', icon: Icons.person_pin),
                        CommonFunctions.commonSpace(height * 0.02, 0),
                        EditTextField(Controller: branchIDController, textTheme: textTheme, hintext: 'Enter BranchID', icon: Icons.store),
                        CommonFunctions.commonSpace(height * 0.06, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                  side: BorderSide(color: primaryColor),
                                  minimumSize: Size(width, height * 0.08),
                                ),
                                onPressed: () async {
                                  print('Press');
                                  CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                                  await Future.delayed(const Duration(seconds: 3));
                                  Provider.of<AdminProvider>(context, listen: false).removeBMImage();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Discard',
                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
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
                                  print('Chalo g');
                                  Provider.of<AdminProvider>(context, listen: false).setSavingStatus();
                                  String? name = auth.currentUser!.email;
                                  if(Provider.of<AdminProvider>(context, listen: false).branchManagerProfileImage!=null)
                                    {
                                      final productImage = Provider.of<AdminProvider>(context, listen: false).branchManagerProfileImage;
                                      await UserController.uploadBMImageToFirebaseStorage(images: productImage!, context: context, imageNAme: name);
                                      newImage = Provider.of<AdminProvider>(context, listen: false).bmImageUrl;
                                    }
                                  else
                                    {
                                      newImage=Provider.of<AdminProvider>(context, listen: false).bm.branchManagerImage;
                                    }

                                  BranchManagerData vendorDetail = BranchManagerData(
                                    branchManagerImage: newImage ,
                                    bMUserName: userNameController.text.isNotEmpty ? userNameController.text : Provider.of<AdminProvider>(context, listen: false).bm.bMUserName!,
                                    bMFullName: fullNameController.text.isNotEmpty ? fullNameController.text : Provider.of<AdminProvider>(context, listen: false).bm.bMFullName!,
                                    branchID: branchIDController.text.isNotEmpty ? branchIDController.text : Provider.of<AdminProvider>(context, listen: false).bm.branchID!,
                                    bMPassword: Provider.of<AdminProvider>(context, listen: false).bm.bMPassword!,
                                    role: 'Branch Manager',
                                  );
                                  await services.updateBMData(context: context, details: vendorDetail);
                                  Provider.of<AdminProvider>(context, listen: false).loadUserDataIntoMemory();
                                  Provider.of<AdminProvider>(context, listen: false).setSavingStatus();
                                  setState(() {});
                                },
                                child: Provider.of<AdminProvider>(context).isSaving
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
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditTextField extends StatelessWidget {
  const EditTextField({
    Key? key,
    required this.Controller,
    required this.textTheme,
    required this.hintext,
    required this.icon,
  }) : super(key: key);

  final TextEditingController Controller;
  final TextTheme textTheme;
  final String hintext;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: Controller,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        fillColor: grey,
        filled: true,
        hintText: hintext,
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
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
    );
  }
}
