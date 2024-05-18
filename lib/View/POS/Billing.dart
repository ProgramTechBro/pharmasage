import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Controller/AdminController/POSController.dart';
import 'package:pharmasage/Controller/Provider/InventoryCartProvider.dart';
import 'package:pharmasage/Controller/Provider/POSProvider.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';
import 'package:pharmasage/Model/Transaction/TransactionDetails.dart';
import 'package:pharmasage/View/InventoryDatabase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/CommonFunctions.dart';
import '../../Model/InventoryCartModel/InevntoryCart.dart';
import '../../Model/POS/POSProduct.dart';
import '../../Utils/colors.dart';
class BillingPage extends StatefulWidget {
  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  InventoryDatabaseHelper helper=InventoryDatabaseHelper();
  MedicalStore store=MedicalStore();
  CommonFunctions functions = CommonFunctions();
  bool isBillingCompleted=false;
  String dropDownValue = 'Select Category';
  String storeId = '';
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot>? productsData;
  double totalPrice=0.0;

  @override
  void initState() {
    super.initState();
    _initializeState();
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
  String getCurrentTimeFormatted() {
    // Get the current time
    DateTime now = DateTime.now();

    // Create a DateFormat instance with the desired format
    DateFormat formatter = DateFormat('hh:mm a');

    // Format the time and return it as a string
    String formattedTime = formatter.format(now);

    return formattedTime;
  }
  String generateTransactionId() {
    // Generate a random number between 100 and 900
    int randomNumber = Random().nextInt(801) + 100;

    // Concatenate "R" with the random number to create the order ID
    String transactionId = 'T$randomNumber';

    return transactionId;
  }
  Future<void> _initializeState() async {
    final branchId = await getBranchIdFromSharedPreferences();
    setState(() {
      storeId = branchId;
    });
    print(storeId);
    // Fetch data upon initialization
    fetchData();
    Map<String, dynamic> storeData = await fetchStoreData(storeId);
    store = MedicalStore.fromMap(storeData);
  }
  Future<Map<String, dynamic>> fetchStoreData(String storeId) async {
    try {
      final DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('Medical Stores')
          .doc(storeId)
          .get();

      if (storeSnapshot.exists) {
        final storeData = storeSnapshot.data() as Map<String, dynamic>;
        return storeData;
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      throw Exception('Error fetching store data: $e');
    }
  }

  Future<void> fetchData() async {
    if (storeId.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Inventory')
          .doc(storeId)
          .collection('Products')
          .get();
      setState(() {
        productsData = querySnapshot.docs;
      });
    }
  }

  List<DocumentSnapshot> filteredData() {
    if (productsData == null) return [];
    List<DocumentSnapshot> filteredList = [];
    // Apply filters based on search query and dropdown selection
    for (DocumentSnapshot product in productsData!) {
      if (dropDownValue == 'Select Category' ||
          product['productCategory'] == dropDownValue) {
        String productName = product['productName'].toString().toUpperCase();
        if (productName.contains(searchQuery.toUpperCase())) {
          filteredList.add(product);
        }
      }
    }
    return filteredList;
  }
  onPressed()async
  {
    setState(() {
      isBillingCompleted=true;
    });

    String transactionDate=getCurrentDateFormatted();
    String transactionTime=getCurrentTimeFormatted();
    final selectedProducts=Provider.of<InventoryCartProvider>(context,listen: false).selectedProducts;
    String transactionId=Provider.of<POSProvider>(context,listen: false).tID;
    double subTotal=Provider.of<InventoryCartProvider>(context,listen: false).totalPrice-6.0;
    double total=Provider.of<InventoryCartProvider>(context,listen: false).totalPrice;
    String storeName=store.branchName!;
    String storeLocation=store.branchLocation!;
    // Create a list of products from cart items
    TransactionModel tModel=TransactionModel(
      transactionID: transactionId,
      transactionDate:transactionDate,
      transactionTime: transactionTime,
      storeName:storeName,
      storeLocation:storeLocation,
      subTotalAmount: subTotal,
      tax: 6.0,
      totalAmount: total,
      selectedProducts: selectedProducts,

    );
    await POSController.addTransaction(context: context, model: tModel,storeId: storeId);
    await fetchData();
    setState(() {
      isBillingCompleted=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final provider=Provider.of<POSProvider>(context);
    final inventoryProvider=Provider.of<InventoryCartProvider>(context);
    return Scaffold(
      backgroundColor: Color(0XFD9D9D9),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: width * 0.68,
              height: height * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                    height: height * 0.06,
                    width: width,
                    child: Center(
                      child: Text(
                        'Product Section',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.15,
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: TextField(
                                      cursorColor: Colors.grey,
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        labelText: 'Search by code or name',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: height * 0.034),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value.trim(); // Update the search query
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                                Container(
                                  height: height * 0.089,
                                  width: width * 0.2,
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButton(
                                    value: dropDownValue,
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    items: functions.productCategories.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(color: Colors.grey.shade600),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropDownValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Color(0XF8FB3B9),
                            height: height * 0.08,
                            width: width,
                            child: Row(
                              children: [
                                CommonFunctions.commonSpace(0, width * 0.02),
                                Text('IMAGE',
                                    style: textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                                SizedBox(width: width * 0.04),
                                Text('NAME',
                                    style: textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                                SizedBox(width: width * 0.22),
                                Text('PRODUCT ID',
                                    style: textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                                SizedBox(width: width * 0.04),
                                Text('QUANTITY',
                                    style: textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                                SizedBox(width: width * 0.04),
                                Text('PRICE',
                                    style: textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                                SizedBox(width: width * 0.04),
                              ],
                            ),
                          ),
                          CommonFunctions.commonSpace(height * 0.02, width),
                          Expanded(
                            child:productsData == null
                                ? Center(child: CircularProgressIndicator(color: primaryColor,))
                                : filteredData().isEmpty
                                ? Center(
                              child: Text('No products found for this category'),
                            )
                                :  ListView.builder(
                              itemCount: filteredData().length,
                              itemBuilder: (context, index) {
                                final product = filteredData()[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap:(){

                                        //Adding product to temporary List
                                        final productSnapshot = InventoryProduct.fromMap(product.data() as Map<String, dynamic>);
                                        Provider.of<InventoryCartProvider>(context, listen: false).addProductToBilling(productSnapshot);
                                      },
                                      child: Container(
                                        color: Color(0XF8FB3B9),
                                        height: height * 0.08,
                                        width: width,
                                        child: Row(
                                          children: [
                                            CommonFunctions.commonSpace(0, width * 0.02),
                                            Container(
                                              width: width * 0.03,
                                              height: height * 0.06,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: product['productImage'] != null
                                                    ? Image.network(
                                                  product['productImage'],
                                                  fit: BoxFit.cover,
                                                )
                                                    : Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.04),
                                            Container(
                                              height: height * 0.08,
                                              width: width * 0.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['productName'] ?? '',
                                                    style: textTheme.labelLarge!
                                                        .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                                                  ),
                                                  Text(
                                                    product['productCategory'] ?? '',
                                                    style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width * 0.045),
                                            Container(
                                              width: width * 0.05,
                                              height: height * 0.08,
                                              child: Center(
                                                child: Text(
                                                  product['productID'] ?? '',
                                                  style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.049),
                                            Container(
                                              width: width * 0.05,
                                              height: height * 0.08,
                                              child: Center(
                                                child: Text(
                                                  product['productQuantity'].toString() ?? '',
                                                  style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.03),
                                            Container(
                                              width: width * 0.08,
                                              height: height * 0.08,
                                              child: Center(
                                                child: Text(
                                                  product['sellingPrice'].toString() ?? '',
                                                  style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            //SizedBox(width: width * 0.08),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CommonFunctions.commonSpace(height * 0.03, width),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: width * 0.3,
              height: height * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                    height: height * 0.06,
                    width: width,
                    child: Center(
                      child: Text(
                        'Billing Section',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: height*0.1,
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                        side: BorderSide(color:primaryColor),
                                        minimumSize: Size(width, height*0.08),
                                      ),
                                      onPressed: ()  {
                                        provider.resetTID();
                                        inventoryProvider.resetBilling();
                                      },

                                      child:Text('Clear Cart',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: primaryColor),)),
                                ),
                                CommonFunctions.commonSpace(0, width*0.04),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                        minimumSize: Size(width, height*0.08),
                                      ),
                                      onPressed:(){
                                             String tId=generateTransactionId();
                                             provider.updateTID(tId);
                                             inventoryProvider.resetBilling();
                                        },
                                      child:Text('New Order',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //CommonFunctions.commonSpace(height*0.02,0),
                  Container(
                    height: height*0.1,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Row(
                      children: [
                        Text('TID:',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: primaryColor)),
                        CommonFunctions.commonSpace(0,width*0.02),
                        Consumer(
                          builder: (context,POSProvider, _) {
                            return Container(
                              height: height * 0.06,
                              width: width * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0XFD9D9D9)), // Adjust the radius as needed
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  provider.tID,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                 Container(
                   height: height*0.3,
                   width: width*0.28,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     color: Colors.white,
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Container(
                         height:height*0.05,
                   padding: EdgeInsets.symmetric(horizontal: width*0.01),
                   decoration: BoxDecoration(
                   border: Border.all(color: Colors.black)
                 ),
                         child:Row(
                           children: [
                             Text('ITEM',
                                 style: textTheme.labelLarge!
                                     .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                             SizedBox(width: width * 0.1),
                             Text('QTY',
                                 style: textTheme.labelLarge!
                                     .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                             SizedBox(width: width * 0.04),
                             Text('Price',
                                 style: textTheme.labelLarge!
                                     .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                             SizedBox(width: width * 0.02),
                             Text('Action',
                                 style: textTheme.labelLarge!
                                     .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),

                           ],
                         ),
                       ),
                       Expanded(child:Container(
                         //padding: EdgeInsets.symmetric(horizontal: width*0.01),
                         decoration: BoxDecoration(
                             border: Border.all(color: Colors.black)
                         ),
                         child: Consumer<POSProvider>(
                           builder: (context,provider,child)
                           {
                             if(inventoryProvider.selectedProducts.isEmpty)
                             {
                               return Container();
                             }
                             else
                             {
                               return ListView.builder(
                                   itemCount: inventoryProvider.selectedProducts.length,
                                   itemBuilder: (context,index)
                                   {
                                     final product = inventoryProvider.selectedProducts[index];
                                     return Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Container(
                                           height: height*0.08,
                                           padding: EdgeInsets.symmetric(vertical: height*0.01),
                                           color: Color(0XF8FB3B9),
                                           child:Row (
                                             children: [
                                               //CommonFunctions.commonSpace(0, width*0.01),
                                               Container(
                                                 height: height*0.08,
                                                 width: width*0.08,
                                                 //color: Colors.blue,
                                                 child: Center(child: Text(product.productName!,style: textTheme.labelLarge,)),
                                               ),
                                               CommonFunctions.commonSpace(0, width*0.02),
                                               Container(
                                                 height: height*0.04,
                                                 width: width*0.08,

                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(10),
                                                   color: primaryColor,
                                                 ),
                                                 child: Center(
                                                   child: Row(
                                                     children: [
                                                       InkWell(
                                                         onTap:(){
                                                           //Increasing Product Quantity
                                                           inventoryProvider.increaseProductQuantity(product);
                                                         },
                                                         child: Container(
                                                             height:height*0.04,width:width*0.02,
                                                             child: const Center(child: Icon(Icons.add, color: Colors.white,size: 15,))),
                                                       ),
                                                       CommonFunctions.commonSpace(0, width*0.01),
                                                       Container(height:height*0.04,width:width*0.02,color:Colors.white,child: Center(child: Text(product.productQuantity.toString(),style: textTheme.labelLarge,))),
                                                       CommonFunctions.commonSpace(0, width*0.01),
                                                       InkWell(
                                                         onTap:(){
                                                           //Decreasing Product Quantity
                                                           inventoryProvider.decreaseProductQuantity(product);
                                                         },
                                                         child: Container(
                                                             height:height*0.04,width:width*0.02,
                                                             child: const Center(child: Icon(Icons.remove, color: Colors.white,size: 15,))),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                               CommonFunctions.commonSpace(0, width*0.01),
                                               Container(
                                                 height: height*0.08,
                                                 width: width*0.04,
                                                 child: Center(child: Text(product.sellingPrice.toString(),style: textTheme.labelLarge,)),
                                               ),
                                               CommonFunctions.commonSpace(0, width*0.01),
                                               GestureDetector(
                                                 onTap: (){
                                                   //final product = inventoryProvider.selectedProducts[index];
                                                   inventoryProvider.removeProductFromBilling(product);
                                                 },
                                                 child: Container(
                                                   height: height*0.035,
                                                   width: width*0.02,
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(30),
                                                     color: Colors.red,
                                                   ),
                                                   child: Icon(Icons.delete_forever,color: white,size: 15,),
                                                 ),
                                               )
                                             ],
                                           ),
                                         ),
                                         CommonFunctions.commonSpace(height*0.01,0)
                                       ],
                                     );
                                   }
                               );
                             }
                           },
                         ),
                       ),
                       )
                     ],
                   ),
                 ),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Container(
                    height: height*0.15,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount:',style: textTheme.bodyMedium),
                            CommonFunctions.commonSpace(0,width*0.02),
                            Text('0.0',style: textTheme.bodyMedium),
                          ],
                        ),
                        CommonFunctions.commonSpace(height*0.01,0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax included:',style: textTheme.bodyMedium),
                            CommonFunctions.commonSpace(0,width*0.02),
                            Text('6.0',style: textTheme.bodyMedium),
                          ],
                        ),
                        CommonFunctions.commonSpace(height*0.01,0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:',style: textTheme.bodyMedium),
                            CommonFunctions.commonSpace(0,width*0.02),
                            Consumer<InventoryCartProvider>(
                                builder:(context,provider,key){
                                  double finalPrice=provider.totalPrice+6.0;
                                  return Text('\RS ${finalPrice.toStringAsFixed(2)}',style: textTheme.bodyMedium,);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        minimumSize: Size(width*0.15, height*0.08),
                      ),
                      onPressed:onPressed,
                      child:isBillingCompleted
                          ? CircularProgressIndicator(color: white)
                          : Text('Save',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
                ],
              ),
            ),

          ],
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