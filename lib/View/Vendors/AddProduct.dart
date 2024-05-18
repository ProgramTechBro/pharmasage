import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
import 'package:pharmasage/Model/Product/Productdetails.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Controller/AdminController/VendorProfile.dart';
import '../../Controller/Provider/ProductProvider.dart';
import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CommonFunctions functions=CommonFunctions();
  String dropDownValue='Select Category';
  TextEditingController pidController=TextEditingController();
  TextEditingController pNameController=TextEditingController();
  TextEditingController pComController=TextEditingController();
  TextEditingController pPriceController=TextEditingController();
  bool addProductBtnPressed=false;
  @override
  onPressed()async
  {
    setState(() {
      addProductBtnPressed=true;
    });
    String name=pidController.text;
    final productImage = Provider.of<ProductProvider>(context,listen: false).productImage;
    if (productImage != null && productImage.existsSync() && productImage.lengthSync() > 0) {
      await OrderController.uploadImageToFirebaseStorage(images: Provider.of<ProductProvider>(context,listen: false).productImage!, context: context,imageNAme: name);
     String productImage=Provider
         .of<ProductProvider>(context,listen: false).imageUrL;
      String sellerID = services.auth.currentUser!.email!;
      Product productDetails=Product(
        productSellerId: sellerID,
        productImage: productImage,
          productID: pidController.text,
          productName: pNameController.text,
        productCategory: dropDownValue,
        productCompany: pComController.text,
        productPrice: double.parse(pPriceController.text),
        quantity: 1,
      );
      await OrderController.addProduct(
          context: context, productModel: productDetails);
      pidController.clear();
      pNameController.clear();
      pComController.clear();
      pPriceController.clear();
      setState(() {
        addProductBtnPressed = false;
      });
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
        title:Text('Add New Product', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ProductProvider>(
                  builder: (context,productProvider,child){
                    return Builder(builder: (context){
                      if(productProvider.productImage==null)
                      {
                        return InkWell(
                          onTap: (){
                            productProvider.fetchProductImagesFromGallery(context: context);
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
                                Text('Add product',style: textTheme.displayMedium!.copyWith(color: greyShade3),)
                              ],
                            ),
                          ),
                        );
                      }
                      else
                      {
                        File images=Provider.of<ProductProvider>(context,listen: false).productImage!;
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
                CommonFunctions.commonSpace(height*0.03, 0),
                Text('Enter Product ID',style: textTheme.bodyMedium,),
                CommonFunctions.commonSpace(height*0.01, 0),
                InputTextFieldSeller( controller:pidController,title: 'Product ID', textTheme: textTheme),
                CommonFunctions.commonSpace(height*0.01, 0),
                Text('Enter Product Name',style: textTheme.bodyMedium,),
                CommonFunctions.commonSpace(height*0.01, 0),
                InputTextFieldSeller( controller:pNameController,title: 'Product Name', textTheme: textTheme),
                CommonFunctions.commonSpace(height*0.01, 0),
                productCategoryDropdown(textTheme, height, width),
                CommonFunctions.commonSpace(height*0.01, 0),
                Text('Enter Company Name',style: textTheme.bodyMedium,),
                CommonFunctions.commonSpace(height*0.01, 0),
                InputTextFieldSeller( controller:pComController,title: 'Brand Name', textTheme: textTheme),
                CommonFunctions.commonSpace(height*0.01, 0),
                Text('Enter Product Price ',style: textTheme.bodyMedium,),
                CommonFunctions.commonSpace(height*0.01, 0),
                InputTextFieldSeller( controller:pPriceController,title: 'Brand Name', textTheme: textTheme),
                CommonFunctions.commonSpace(height*0.04, 0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                    minimumSize: Size(width, height * 0.08),
                  ),
                  onPressed: onPressed,
                  child: addProductBtnPressed
                      ? CircularProgressIndicator(color: white)
                      : Text(
                    'Add product',
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
  Column productCategoryDropdown(TextTheme textTheme,double height,double width)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Category',style: textTheme.bodyMedium,),
        CommonFunctions.commonSpace(height*0.01, 0),
        Container(
          height: height*0.085,
          padding: EdgeInsets.symmetric(horizontal: width*0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: grey),
            color: grey,
          ),
          alignment: Alignment.center,
          child:DropdownButton(
            value: dropDownValue,
            underline: const SizedBox(),
            isExpanded: true,
            icon:const Icon(Icons.keyboard_arrow_down,),
            items: functions.productCategories.map((String items){
              return DropdownMenuItem(
                  value: items,
                  child:Text(items,style:TextStyle(color: Colors.grey.shade600),));

            }).toList(),
            onChanged: (String? newValue){
              setState(() {
                dropDownValue=newValue!;
              });
            },
          ) ,
        )

      ],
    );
  }
}
