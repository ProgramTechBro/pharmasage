
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Model/POS/POSProduct.dart';
import 'package:pharmasage/View/POS/InventoryProduct.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Controller/AdminController/POSController.dart';
import '../../Controller/Provider/POSProvider.dart';
import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
class EditPOSProduct extends StatefulWidget {
  final DocumentSnapshot<Object?> product;
  final String storeId;
  const EditPOSProduct({super.key,required this.product,required this.storeId});

  @override
  State<EditPOSProduct> createState() => _EditPOSProductState();
}

class _EditPOSProductState extends State<EditPOSProduct> {
  String productImage='';
  String newProductImage='';
  String imageName='';
  String storeId='';
  bool isProductUpdating=false;
  TextEditingController productNameController=TextEditingController();
  TextEditingController productCategory=TextEditingController();
  TextEditingController lowStockController=TextEditingController();
  TextEditingController productIDController=TextEditingController();
  TextEditingController productQuantityController=TextEditingController();
  TextEditingController expiryDateController=TextEditingController();
  TextEditingController costPriceController=TextEditingController();
  TextEditingController sellingController=TextEditingController();
  void initState() {
    super.initState();
    final productData = widget.product.data() as Map<String, dynamic>;
    productNameController.text = productData['productName'] ?? '';
    productCategory.text = productData['productCategory'] ?? '';
    lowStockController.text = productData['lowStockWarning']?.toString() ?? '';
    productIDController.text = productData['productID'] ?? '';
    productQuantityController.text = productData['productQuantity']?.toString() ?? '';
    expiryDateController.text = productData['productExpiry'] ??'';
    costPriceController.text = productData['costPrice']?.toString() ?? '';
    sellingController.text = productData['sellingPrice']?.toString() ?? '';
    productImage=productData['productImage']??'';
    imageName=productData['productID']??'';
    storeId=widget.storeId;
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
            preferredSize:Size.fromHeight(height * 0.12),
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
                    child: Center(child: Text('Edit Product',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),)),
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
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: height * 0.23,
                                                    width: width * 0.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(color: Colors.grey),
                                                      image: DecorationImage(
                                                        image: NetworkImage(productImage), // Replace with your default image URL
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 8,
                                                    right: 8,
                                                    child: InkWell(
                                                      onTap: () {
                                                        productProvider.fetchPOSProductImagesFromGallery(context: context);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.3), // Shadow color
                                                              spreadRadius: 2, // Spread radius
                                                              blurRadius: 4, // Blur radius
                                                              offset: Offset(0, 2), // Offset of the shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: height * 0.03,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              final Uint8List? images = productProvider.posProductImage;
                                              if (images != null) {
                                                return Stack(
                                                  children: [
                                                    Container(
                                                      height: height * 0.23,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        image: DecorationImage(
                                                          image: MemoryImage(images), // Use MemoryImage to load Uint8List as image
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 8,
                                                      right: 8,
                                                      child: InkWell(
                                                        onTap: () {
                                                          productProvider.fetchPOSProductImagesFromGallery(context: context);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.3), // Shadow color
                                                                spreadRadius: 2, // Spread radius
                                                                blurRadius: 4, // Blur radius
                                                                offset: Offset(0, 2), // Offset of the shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: height * 0.03,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            minimumSize: Size(width*0.1, height * 0.08),
                          ),
                          onPressed: ()async{
                            CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                            await Future.delayed(const Duration(seconds: 3));
                            Provider.of<POSProvider>(context, listen: false).removePOSImage();
                            Navigator.pop(context);
                          },
                          child:  Text(
                            'Discard',
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        CommonFunctions.commonSpace(0,width*0.02),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            minimumSize: Size(width*0.1, height * 0.08),
                          ),
                          onPressed: ()async{
                            setState(() {
                              isProductUpdating=true;
                            });
                            if(Provider.of<POSProvider>(context, listen: false).posProductImage!=null){
                              final productImage = Provider.of<POSProvider>(context, listen: false).posProductImage;
                              await POSController.uploadUpdatedPOSProductImageToFirebaseStorage(images: productImage!, context: context, imageNAme: imageName);
                              newProductImage = Provider.of<POSProvider>(context, listen: false).posImageUrL;
                            }
                            else
                            {
                              newProductImage=productImage;
                            }
                            InventoryProduct product=InventoryProduct(
                              productImage: newProductImage,
                              productID: productIDController.text,
                              productName: productNameController.text,
                              productQuantity: int.tryParse(productQuantityController.text),
                              productCategory: productCategory.text,
                              productExpiry: expiryDateController.text,
                              lowStockWarning: int.tryParse(lowStockController.text),
                              costPrice:double.tryParse(costPriceController.text),
                              sellingPrice: double.tryParse(sellingController.text),
                            );
                            await POSController.updatePOSProductData(context: context, details: product, storeId: storeId);

                            setState(() {
                              isProductUpdating=false;
                            });
                            await Future.delayed(const Duration(seconds: 3));
                            Navigator.pop(context);
                          },
                          child: isProductUpdating
                              ? CircularProgressIndicator(color: white)
                              : Text(
                            'Save',
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonFunctions.commonSpace(height*0.02, 0)
                ],
              ),
            ),
          ),
    ),
    );
  }
}
