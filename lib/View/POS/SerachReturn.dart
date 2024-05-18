import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/POSController.dart';
import 'package:pharmasage/Controller/Provider/POSProvider.dart';
import 'package:pharmasage/Controller/Provider/ReturnProvider.dart';
import 'package:pharmasage/Model/ReturnModel/ReturnModel.dart';
import 'package:pharmasage/Model/ReturnProduct/ReturnProduct.dart';
import 'package:pharmasage/Model/Transaction/TransactionDetails.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/POS/POSProduct.dart';
class SearchReturnResult extends StatefulWidget {
  final TransactionModel transactionModel;
  const SearchReturnResult({super.key,required this.transactionModel});

  @override
  State<SearchReturnResult> createState() => _SearchReturnResultState();
}

class _SearchReturnResultState extends State<SearchReturnResult> {
  //final TextEditingController quantityController = TextEditingController(text: '1');
  TextEditingController commentController=TextEditingController();
  int length=1;
  bool isReturnCompleted=false;
  InventoryProduct sameProduct=InventoryProduct();
  String returnId='';
  String returnDate='';
  List<ReturnProduct> saveProducts=[];
  String returnTime='';
  String againstInvoice='';
  List<String> products=[];
  //List <String> dropDownValues=[];
  //String dropDownValue='Product';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    returnId=generateReturnId();
    returnDate=getCurrentDateFormatted();
    returnTime=getCurrentTimeFormatted();
    againstInvoice=widget.transactionModel.transactionID!;
    products=getProductNames(widget.transactionModel);
    //dropDownValues = List.filled(length, 'Product');
    //setDropDownValues();

  }
  // Future<void> setDropDownValues() async {
  //   await Future.delayed(Duration.zero);
  //   int length=Provider.of<POSProvider>(context,listen: false).returnProductQuantity;
  //   print('Length $length');// Wait until the build method completes
  //
  // }
  List<String> getProductNames(TransactionModel transactionModel) {
    List<String> productNames = ['Product']; // Add default value
    for (InventoryProduct product in transactionModel.selectedProducts!) {
      productNames.add(product.productName!);
    }
    print('Products Name $productNames');
    return productNames;
  }
  Future<InventoryProduct?> findProductByName(String productName) async {
    // Loop through the list of selected products in the transaction model
    for (InventoryProduct product in widget.transactionModel.selectedProducts!) {
      // Check if the product name matches
      if (product.productName == productName) {
        // Return the product object if found
        return product;
      }
    }
    // Return null if no matching product is found
    return null;
  }
  void updateProductPrice(String productName)async
  {
    sameProduct=(await findProductByName(productName))!;
    Provider.of<ReturnProvider>(context,listen: false).addProductToBilling(sameProduct);
  }

  String generateReturnId() {
    // Generate a random number between 100 and 900
    int randomNumber = Random().nextInt(801) + 100;

    // Concatenate "R" with the random number to create the order ID
    String transactionId = 'RT$randomNumber';

    return transactionId;
  }
  String getCurrentTimeFormatted() {
    // Get the current time
    DateTime now = DateTime.now();

    // Create a DateFormat instance with the desired format
    DateFormat formatter = DateFormat('hh:mm a');

    // Format the time and return it as a string
    String formattedTime = formatter.format(now);

    return formattedTime;
  }
  String getCurrentDateFormatted() {
    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateFormat instance with the desired format
    DateFormat formatter = DateFormat('dd MMM yyyy');

    // Format the date and return it as a string
    String formattedDate = formatter.format(now);

    return formattedDate;
  }
  onPressed()async{
    setState(() {
      isReturnCompleted=true;
    });
    String storeId=await getBranchIdFromSharedPreferences();
    //String againstInvoice=widget.transactionModel.transactionID!;
    String storeName=widget.transactionModel.storeName!;
    String storeLocation=widget.transactionModel.storeLocation!;
    double totalAmount=Provider.of<ReturnProvider>(context,listen: false).returnTotalPrice!;
    String comment=commentController.text;
    final saveProvider=Provider.of<ReturnProvider>(context,listen: false);
    for (int i = 0; i < saveProvider.returnedProducts.length; i++) {
      // Get the current returned product
      final returnedProduct = saveProvider.returnedProducts[i];

      // Create a ReturnProduct object
      ReturnProduct product = ReturnProduct(
        productID: returnedProduct.productID,
        productName: returnedProduct.productName,
        productQuantity: returnedProduct.productQuantity,
        returnProductPrice:returnedProduct.sellingPrice,
      );
      saveProducts.add(product);
    }
    ReturnedProductModel returnedProductModel=ReturnedProductModel(
      returnID: returnId,
      returnDate: returnDate,
      returnTime: returnTime,
      returnAgainst: againstInvoice,
      storeName: storeName,
      storeLocation: storeLocation,
      comment: comment,
      totalAmount: totalAmount,
      selectedReturnedProducts: saveProducts,
    );
    await POSController.addReturnedTransaction(context: context, model: returnedProductModel, storeId: storeId);
    commentController.clear();
    returnId='';
    returnDate='';
    returnTime='';
    againstInvoice='';

    setState(() {
      isReturnCompleted=false;
    });
  }
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final provider=Provider.of<POSProvider>(context);
    final returnProvider=Provider.of<ReturnProvider>(context);
    return SafeArea(
      child: Scaffold(
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
            width: width*0.6,
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
                  child: Center(child: Text('Claim Invoice',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),)),
                ),
                //CommonFunctions.commonSpace(height*0.02,0),
                Container(
                  width: width,
                  height: height*0.06,
                  padding: EdgeInsets.symmetric(horizontal: width*0.04),
                  child: Center(
                    child: Row(
                      children: [
                        Text('Return ID:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
                        CommonFunctions.commonSpace(0,width*0.01),
                        Text(returnId??'',style: textTheme.bodyMedium!),
                    ],
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height*0.005,0),
                Container(
                  width: width,
                  height: height*0.06,
                  padding: EdgeInsets.symmetric(horizontal: width*0.04),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Return Date:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
                            CommonFunctions.commonSpace(0,width*0.01),
                            Text(returnDate??'',style: textTheme.bodyMedium!),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Against Invoice:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
                            CommonFunctions.commonSpace(0,width*0.01),
                            Text(againstInvoice!??'',style: textTheme.bodyMedium!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height*0.005,0),
                Container(
                  width: width,
                  height: height*0.05,
                  padding: EdgeInsets.symmetric(horizontal: width*0.04),
                  child: Center(
                    child: Row(
                      children: [
                        Text('No of Products:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
                        CommonFunctions.commonSpace(0,width*0.01),
                        Container(
                          height: height*0.06,
                          width: width*0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  returnProvider.IncreaseValue();
                                  provider.increaseReturnProductQuantity();
                                },
                                child: Container(
                                  width: width*0.03,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(child:Icon(Icons.add,color: white,)),
                                ),
                              ),
                              Container(
                                width: width*0.02,
                                  color: Colors.white,
                                  child: Center(child: Text(provider.returnProductQuantity.toString(),style: textTheme.labelLarge!))
                              ),
                              GestureDetector(
                                onTap: (){
                                  returnProvider.decreaseValue();
                                  provider.decreaseReturnProductQuantity();
                                },
                                child: Container(
                                  width: width*0.03,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(child:Icon(Icons.remove,color: white,)),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height*0.01,0),
                Container(
                  height: height*0.3,
                  width: width,
                  //color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: width*0.04),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Product',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                            CommonFunctions.commonSpace(0, width*0.15),
                            Text('Quantity',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                            CommonFunctions.commonSpace(0, width*0.08),
                            Text('Price',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                            CommonFunctions.commonSpace(0, width*0.08),
                          ],
                        ),
                        CommonFunctions.commonSpace(height*0.01,0),
                        Container(
                          height: height*0.25,
                          //color: Colors.blue,
                          child: ListView.builder(
                            itemCount: provider.returnProductQuantity,
                            itemBuilder: (context, index) {
                              print('Index2 $index');
                              // Access the product at the given index, if it exists
                              final product = returnProvider.returnedProducts.isNotEmpty && index<returnProvider.returnedProducts.length
                                  ? returnProvider.returnedProducts[index]
                                  : null;

                              return Column(
                                children: [
                                  Container(
                                    height: height * 0.1,
                                    color: CupertinoColors.systemGrey5,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: height * 0.06,
                                            width: width * 0.15,
                                            padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.grey),
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: DropdownButton(
                                              value: returnProvider.dropDownValues[index],
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              icon: Icon(Icons.keyboard_arrow_down),
                                              items: products.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: TextStyle(color: Colors.grey.shade600),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {

                                                if(returnProvider.dropDownValues[index]!='Product')
                                                {
                                                  return;
                                                }
                                                else
                                                  {
                                                    setState(() {
                                                      print('Index $index');
                                                      returnProvider.changeDropDownValueAtIndex(index, newValue!);
                                                      updateProductPrice(newValue);
                                                    });
                                                  }
                                                // setState(() {
                                                //       print('Index $index');
                                                //       returnProvider.changeDropDownValueAtIndex(index, newValue!);
                                                //       updateProductPrice(newValue);
                                                //     });
                                              },
                                            ),
                                          ),
                                          CommonFunctions.commonSpace(0, width * 0.048),
                                          Container(
                                            height: height * 0.06,
                                            width: width * 0.05,
                                            child: TextField(
                                              controller: returnProvider.quantityController[index],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Enter Qty',
                                                labelStyle: TextStyle(fontSize: 12),
                                              ),
                                              style: TextStyle(fontSize: 12),
                                              onChanged: (value) {
                                                print('Helloss');
                                                if (value == null || value.isEmpty) {
                                                  return;
                                                }
                                                int quantity = int.tryParse(value) ?? 1;
                                                if (quantity > 0) {
                                                  print('New Value $value');
                                                  returnProvider.updateProductQuantity(index, quantity);
                                                }
                                              },
                                              // Set default value for quantity field
                                              // Use the product quantity if available, else set it to 1
                                              //initialValue: product != null ? product.quantity.toString() : '1',
                                            ),
                                          ),
                                          CommonFunctions.commonSpace(0, width * 0.065),
                                          Container(
                                            height: height * 0.06,
                                            width: width * 0.05,
                                            child: Center(
                                              // Show the product price if available, else show 'none'
                                              child: Text(
                                                product != null && product.sellingPrice != null
                                                    ? product.sellingPrice.toString()
                                                    : '',
                                                style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  width: width*0.5,
                  height: height*0.0021,
                  color: Colors.grey,
                ),
                //CommonFunctions.commonSpace(height*0.02,0),
                Container(
                  //color: red,
                  height: height*0.04,
                  width: width,
                  child: Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text('Total:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
                          CommonFunctions.commonSpace(0,width*0.01),
                          Text(returnProvider.returnTotalPrice.toString()??'',style: textTheme.bodyMedium!),
                          CommonFunctions.commonSpace(0,width*0.1),
                        ],
                      ),
                    ],
                  ),
                ),
                //CommonFunctions.commonSpace(height*0.02,0),
                Container(
                  height: height*0.1,
                  width: width,
                  //color: Colors.green,
                  padding: EdgeInsets.only(left:width*0.04,right: width*0.2),
                  child: Expanded(
                    child: TextField(
                      cursorColor: Colors.grey,
                      controller: commentController,
                      maxLines: 7,
                      decoration: InputDecoration(
                        hintText: 'Enter a comment',
                        hintStyle: TextStyle(fontSize: 24),
                        filled: true,
                        fillColor: Colors.white,
                        //contentPadding: EdgeInsets.symmetric(vertical: 46.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height*0.02,0),
                Container(
                  width: width,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        minimumSize: Size(width*0.1, height * 0.08),
                      ),
                      onPressed:onPressed,
                      child: isReturnCompleted?CircularProgressIndicator(color: Colors.white,):Text(
                        'Save',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
