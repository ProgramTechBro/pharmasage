import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:provider/provider.dart';
import '../Controller/AdminController/StoreController.dart';
import '../Controller/Provider/StoreProvider.dart';
import '../Utils/widgets/InputTextFiellds.dart';
class AddStore extends StatefulWidget {
  const AddStore({super.key});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  TextEditingController branchNameController=TextEditingController();
  TextEditingController branchIDController=TextEditingController();
  TextEditingController branchLocationController=TextEditingController();
  TextEditingController branchManagerNameController=TextEditingController();
  bool addStoreBtnPressed=false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth=FirebaseAuth.instance;
  String storeImage='';
  @override
  onPressed()async
  {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        addStoreBtnPressed=true;
      });
      String name=branchIDController.text;
      if(Provider.of<StoreProvider>(context,listen: false).storeImage!=null)
      {
        final productImage = Provider.of<StoreProvider>(context,listen: false).storeImage;
        if (productImage != null && productImage.existsSync() && productImage.lengthSync() > 0) {
          await StoreController.uploadImageToFirebaseStorage(images: Provider.of<StoreProvider>(context,listen: false).storeImage!, context: context,imageNAme: name);
          storeImage=Provider
              .of<StoreProvider>(context,listen: false).storeImageUrL;
        }
        else
        {
          storeImage='NULL';
        }

        MedicalStore storeDetails=MedicalStore(
          branchID: branchIDController.text,
          branchImageURL: storeImage,
          branchName: branchNameController.text,
          branchLocation: branchLocationController.text,
          branchManagerName: branchManagerNameController.text,
          branchOwnerName: auth.currentUser!.email,

        );
        await StoreController.addStore(
            context: context, storeModel: storeDetails);
        branchIDController.clear();
        branchNameController.clear();
        branchLocationController.clear();
        branchManagerNameController.clear();
        setState(() {
          addStoreBtnPressed = false;
        });
      }
    }
  }
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:Text('Add New Branch', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<StoreProvider>(
                  builder: (context,productProvider,child){
                    return Builder(builder: (context){
                      if(productProvider.storeImage==null)
                      {
                        return InkWell(
                          onTap: (){
                            productProvider.fetchStoreImagesFromGallery(context: context);
                          },
                          child: Container(
                            height: height*0.23,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: greyShade3),
                            ),
                            child: Column(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,size: height*0.07,color: greyShade3,),
                                Text('Add Store',style: textTheme.displayMedium!.copyWith(color: greyShade3),)
                              ],
                            ),
                          ),
                        );
                      }
                      else
                      {
                        File images=Provider.of<StoreProvider>(context,listen: false).storeImage!;
                        return Container(
                          height: height*0.23,
                          width: width,
                          decoration: BoxDecoration(
                            //color: Colors.amber,
                              image: DecorationImage(
                                image: FileImage(File(images.path)),fit: BoxFit.contain,
                              )
                          ),
                        );
                      }
                    });
                  },
                ),
                CommonFunctions.commonSpace(height*0.03,0 ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Store Details here :',style: textTheme.labelLarge),
                      CommonFunctions.commonSpace(height*0.03,0 ),
                      Text('Branch ID',style: textTheme.bodySmall),
                      CommonFunctions.commonSpace(height*0.008, 0),
                      InputTextFieldSeller( controller:branchIDController,title: 'Branch ID', textTheme: textTheme,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter BranchID';
                          }
                          return null;
                        },),
                      CommonFunctions.commonSpace(height*0.02, 0),
                      Text('Branch Name',style: textTheme.bodySmall),
                      CommonFunctions.commonSpace(height*0.008, 0),
                      InputTextFieldSeller( controller:branchNameController,title: 'Branch Name', textTheme: textTheme,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter BranchName';
                          }
                          return null;
                        },),
                      CommonFunctions.commonSpace(height*0.02, 0),
                      Text('Address',style: textTheme.bodySmall),
                      CommonFunctions.commonSpace(height*0.008, 0),
                      InputTextFieldSeller( controller:branchLocationController,title: 'Branch Location', textTheme: textTheme,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter BranchLocation';
                          }
                          return null;
                        },),
                      CommonFunctions.commonSpace(height*0.02, 0),
                      Text('Branch Manager Name',style: textTheme.bodySmall),
                      CommonFunctions.commonSpace(height*0.008, 0),
                      InputTextFieldSeller( controller:branchManagerNameController,title: 'Branch Manager Name', textTheme: textTheme,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter BranchManager';
                          }
                          return null;
                        },),
                    ],
                ),
                ),
                CommonFunctions.commonSpace(height*0.04, 0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                    minimumSize: Size(width, height * 0.08),
                  ),
                  onPressed: onPressed,
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
      ),
    );
  }

  }
