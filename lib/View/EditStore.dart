import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Service/MedicalStoreServices.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';
import 'package:pharmasage/Model/OrderInvoice/Store.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/AdminController/StoreController.dart';
import '../Controller/Provider/StoreProvider.dart';
import '../Utils/colors.dart';
//StoreController controller=StoreController();
StoreHandler services=StoreHandler();
class EditStore extends StatefulWidget {
  final Map<String, dynamic> storeData;

  const EditStore({required this.storeData});

  @override
  _EditStoreState createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  late TextEditingController _branchIdController;
  late TextEditingController _branchNameController;
  late TextEditingController _branchLocationController;
  late TextEditingController _branchManagerNameController;
  late String previousImage;
   String newImage='';
  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial values
    _branchIdController = TextEditingController(text: widget.storeData['branchID']);
    _branchNameController = TextEditingController(text: widget.storeData['branchName']);
    _branchLocationController = TextEditingController(text: widget.storeData['branchLocation']);
    _branchManagerNameController = TextEditingController(text: widget.storeData['branchManagerName']);
    previousImage=widget.storeData['branchImageURL'];
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
          title: Text('Edit Details', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            //height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height * 0.03, 0),
                Text('Edit Store Details:', style: textTheme.bodyMedium),
                CommonFunctions.commonSpace(height * 0.02, 0),
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
                                Text('Upload new pic',style: textTheme.displayMedium!.copyWith(color: greyShade3),)
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
                CommonFunctions.commonSpace(height * 0.04, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Branch ID:', style: textTheme.bodySmall),
                    CommonFunctions.commonSpace(0, width * 0.06),
                    Container(
                      width: width*0.5,
                      child: TextField(
                        controller: _branchIdController,
                        onChanged: (newValue) {
                          widget.storeData['branchID'] = newValue;
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: width*0.2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2.0,color: grey)
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height * 0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Branch Name:', style: textTheme.bodySmall),
                    CommonFunctions.commonSpace(0, width * 0.06),
                    Container(
                      width: width*0.5,
                      child: TextField(
                        controller: _branchNameController,
                        onChanged: (newValue) {
                          widget.storeData['branchName'] = newValue;
                        },
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        //   hintText: 'Enter branch name',
                        // ),
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height * 0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Branch Location:', style: textTheme.bodySmall),
                    CommonFunctions.commonSpace(0, width * 0.06),
                    Container(
                      width: width*0.5,
                      child: TextField(
                        controller: _branchLocationController,
                        onChanged: (newValue) {
                          widget.storeData['branchLocation'] = newValue;
                        },
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        //   hintText: 'Enter branch location',
                        // ),
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height * 0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Branch Manager:', style: textTheme.bodySmall),
                    CommonFunctions.commonSpace(0, width * 0.06),
                    Container(
                      width: width*0.5,
                      child: TextField(
                        controller: _branchManagerNameController,
                        onChanged: (newValue) {
                          widget.storeData['branchManagerName'] = newValue;
                        },
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        //   hintText: 'Enter branch manager name',
                        // ),
                      ),
                    ),
                  ],
                ),
                CommonFunctions.commonSpace(height*0.06, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            side: BorderSide(color:primaryColor),
                            minimumSize: Size(width, height*0.08),
                          ),
                          onPressed: () async {
                            print('Press');
                            CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                            await Future.delayed(const Duration(seconds: 3));
                            Provider.of<StoreProvider>(context, listen: false).emptyStoreImages();// Wait for 3 seconds
                            Navigator.pop(context);
                          },

                          child:Text('Discard',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: primaryColor),)),
                    ),
                    CommonFunctions.commonSpace(0, width*0.04),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            minimumSize: Size(width, height*0.08),
                          ),
                          onPressed: () async {
                            Provider.of<StoreProvider>(context, listen: false).setStoreSaving();

                            final storeProvider = Provider.of<StoreProvider>(context, listen: false);

                            if (storeProvider.storeImage != null) {
                              final productImage = storeProvider.storeImage;
                              await StoreController.deleteImageFromFirebaseStorage(_branchNameController.text);
                              await StoreController.uploadImageToFirebaseStorage(images: productImage!, context: context, imageNAme: _branchNameController.text);
                              newImage = storeProvider.storeImageUrL;
                              Provider.of<StoreProvider>(context).emptyStoreImages();
                            }
                            else{
                              newImage=previousImage;
                            }

                            final store = MedicalStore(
                              branchImageURL: newImage,
                              branchID: _branchIdController.text,
                              branchName: _branchNameController.text,
                              branchLocation: _branchLocationController.text,
                              branchManagerName: _branchManagerNameController.text,
                            );
                            print('Chalo g');
                            await services.updateMedicalStoreData(context: context, details: store);
                            Provider.of<StoreProvider>(context, listen: false).setStoreSaving();
                            setState(() {});
                          },
                          child:Provider.of<StoreProvider>(context).storeSaving?CircularProgressIndicator(color: Colors.white,):Text('Save',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
                    ),
                  ],
                ),
                // Other fields go here, similarly populated with corresponding storeData values
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController when the widget is disposed
    _branchIdController.dispose();
    _branchNameController.dispose();
    _branchLocationController.dispose();
    _branchManagerNameController.dispose();
    super.dispose();
  }
}
