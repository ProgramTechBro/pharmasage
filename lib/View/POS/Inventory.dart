import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/AdminController/POSController.dart';
import '../../Controller/Provider/POSProvider.dart';
import '../../Model/POS/POSProduct.dart';
import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
class InventoryPagePOS extends StatefulWidget {
  @override
  State<InventoryPagePOS> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPagePOS> {
  TextEditingController productNameController=TextEditingController();
  TextEditingController productCategory=TextEditingController();
  TextEditingController lowStockController=TextEditingController();
  TextEditingController productIDController=TextEditingController();
  TextEditingController productQuantityController=TextEditingController();
  TextEditingController expiryDateController=TextEditingController();
  TextEditingController costPriceController=TextEditingController();
  TextEditingController sellingController=TextEditingController();
  bool addInventoryBtnPressed=false;
  onPressed() async {
    setState(() {
      addInventoryBtnPressed = true;
    });
    String name = productIDController.text;
    final productProvider = Provider.of<POSProvider>(context, listen: false);
    final productImage = productProvider.posProductImage;
    print('Hello1');
    if (productImage != null && productImage.isNotEmpty) {
      await POSController.uploadPOSProductImageToFirebaseStorage(
        images: productImage,
        context: context,
        imageNAme: name,
      );
      print('Hello2');
      String productImageUrl = productProvider.posImageUrL;
      int productQuantity = int.tryParse(productQuantityController.text) ?? 0;
      int lowStock = int.tryParse(lowStockController.text) ?? 0;
      double costPrice = double.tryParse(costPriceController.text) ?? 0.0;
      double sellingPrice = double.tryParse(sellingController.text) ?? 0.0;
      InventoryProduct productDetails = InventoryProduct(
        productExpiry: expiryDateController.text,
        productImage: productImageUrl,
        productID: productIDController.text,
        productName: productNameController.text,
        productCategory: productCategory.text,
        productQuantity: productQuantity,
        lowStockWarning: lowStock,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
      );
      print('Hello3');
      String store = await getBranchIdFromSharedPreferences();
      print('Hello4');
      await POSController.addProduct(
        context: context,
        productModel: productDetails,
        storeId: store,
      );
      productNameController.clear();
      productCategory.clear();
      productIDController.clear();
      productQuantityController.clear();
      lowStockController.clear();
      expiryDateController.clear();
      costPriceController.clear();
      sellingController.clear();
      setState(() {
        addInventoryBtnPressed = false;
      });
    } else {
      CommonFunctions.showWarningToast(
        context: context,
        message: 'No Image Selected',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFD9D9D9),
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
        body: Center(
          child: Container(
            width: width*0.99,
            height: height*0.85,
            //padding: EdgeInsets.symmetric(horizontal: width*0.4,vertical: height*0.4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
              color: CupertinoColors.systemGrey5,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 4, // Blur radius
                  offset: Offset(0, 2), // Offset of the shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Color(0XF8FB3B9),
                  height: height*0.08,
                  width: width,
                  child: Center(child: Text('Add Product',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),)),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: width*0.5,
                            padding: EdgeInsets.symmetric(horizontal: width*0.1),
                            child: Center(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonFunctions.commonSpace(height*0.02,0),
                                    Consumer<POSProvider>(
                                      builder: (context, productProvider, child) {
                                        return Builder(builder: (context) {
                                          if (productProvider.posProductImage == null) {
                                            return InkWell(
                                              onTap: () {
                                                productProvider.fetchPOSProductImagesFromGallery(context: context);
                                              },
                                              child: Container(
                                                height: height * 0.23,
                                                width: width * 0.3,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add, size: height * 0.07, color: Colors.grey),
                                                    Text('Upload pic', style: textTheme.displayMedium!.copyWith(color: Colors.grey)),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            final Uint8List? images = productProvider.posProductImage;
                                            if (images != null) {
                                              return Container(
                                                height: height * 0.23,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  //color: Colors.amber,
                                                  image: DecorationImage(
                                                    image: MemoryImage(images), // Use MemoryImage to load Uint8List as image
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return SizedBox.shrink(); // Return empty container if image data is null
                                            }
                                          }
                                        });
                                      },
                                    ),

                                    CommonFunctions.commonSpace(height*0.03,0 ),
                                    Text('Product Name',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.008, 0),
                                    InputTextFieldSeller( controller:productNameController,title: 'Product Name', textTheme: textTheme,),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    Text('Product Category',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.008, 0),
                                    InputTextFieldSeller( controller:productCategory,title: 'Product Category', textTheme: textTheme),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    Text('Low Stock Warning',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.008, 0),
                                    InputTextFieldSeller( controller:lowStockController,title: 'Low stock Warning', textTheme: textTheme),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: width*0.5,
                            padding: EdgeInsets.symmetric(horizontal: width*0.1),
                            child: Center(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonFunctions.commonSpace(height*0.1,0),
                                    Text('Product ID',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    InputTextFieldSeller( controller:productIDController,title: 'Product ID', textTheme: textTheme),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    Text('Expiry Date',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    InputTextFieldSeller( controller:expiryDateController,suffixIcon:IconButton(
                                      icon: Icon(Icons.calendar_today_outlined),
                                      onPressed: () async {
                                        final DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(DateTime.now().year + 10),
                                        );

                                        if (pickedDate != null) {
                                          // Format the picked date
                                          final formattedDate = DateFormat('dd MMM, yyyy').format(pickedDate);

                                          // Update the value in the text field
                                          expiryDateController.text = formattedDate;
                                        }
                                      },
                                    ),title: 'Expiry Date', textTheme: textTheme),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    Text('Quantity in Stock',style: textTheme.bodyMedium),
                                    CommonFunctions.commonSpace(height*0.02, 0),
                                    InputTextFieldSeller( controller:productQuantityController,title: 'Quantity in Stock', textTheme: textTheme),
                                    CommonFunctions.commonSpace(height*0.02,0),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Cost price',style: textTheme.bodyMedium),
                                                CommonFunctions.commonSpace(height*0.02, 0),
                                                InputTextFieldSeller( controller:costPriceController,title: 'Cost Price', textTheme: textTheme),
                                              ],
                                            ),
                                          ),
                                          CommonFunctions.commonSpace(0, width*0.02),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Selling Price',style: textTheme.bodyMedium),
                                                CommonFunctions.commonSpace(height*0.02, 0),
                                                InputTextFieldSeller( controller:sellingController,title: 'Selling Price', textTheme: textTheme),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
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
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      minimumSize: Size(width*0.1, height * 0.08),
                    ),
                    onPressed: onPressed,
                    child: addInventoryBtnPressed
                        ? CircularProgressIndicator(color: white)
                        : Text(
                      'Save',
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height*0.02, 0)
              ],
            ),
          ),
        )
      ),
    );
  }
  Future<String> getBranchIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? branchId = prefs.getString('branchId');
    return branchId ?? ''; // Return branchId if not null, otherwise return an empty string
  }

}
