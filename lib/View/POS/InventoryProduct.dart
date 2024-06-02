import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/View/POS/EditPosimage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/CommonFunctions.dart';
import '../../Utils/colors.dart';
import 'Inventory.dart';

class InventoryPro extends StatefulWidget {
  const InventoryPro({Key? key}) : super(key: key);

  @override
  State<InventoryPro> createState() => _InventoryProState();
}

class _InventoryProState extends State<InventoryPro> {
  CommonFunctions functions = CommonFunctions();
  String dropDownValue = 'Select Category';
  String storeId = '';
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot>? productsData;

  @override
  void initState() {
    super.initState();
    _initializeState();
    print('Hello g');
  }

  Future<void> _initializeState() async {
    final branchId = await getBranchIdFromSharedPreferences();
    setState(() {
      storeId = branchId;
    });
    print(storeId);
    // Fetch data upon initialization
    fetchData();
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0XFD9D9D9),
      body: Center(
        child: Container(
          width: width * 0.99,
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
                height: height * 0.08,
                width: width,
                child: Center(
                  child: Text(
                    'Inventory Product',
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
                            SizedBox(width: width * 0.03),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                minimumSize: Size(width * 0.13, height * 0.09),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InventoryPagePOS()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.add, color: Colors.white),
                                  Text(
                                    'Add product',
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                            Text('EXPIRY DATE',
                                style: textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                            SizedBox(width: width * 0.04),
                            Text('COST PRICE',
                                style: textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                            SizedBox(width: width * 0.04),
                            Text('SELLING PRICE',
                                style: textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                            SizedBox(width: width * 0.04),
                            Text('ACTIONS',
                                style: textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                                Container(
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
                                      SizedBox(width: width * 0.05),
                                      Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        child: Center(
                                          child: Text(
                                            product['productExpiry'] ?? '',
                                            style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Container(
                                        width: width * 0.05,
                                        height: height * 0.08,
                                        child: Center(
                                          child: Text(
                                            product['costPrice'].toString() ?? '',
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
                                            product['sellingPrice'].toString() ?? '',
                                            style: textTheme.labelLarge!.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.07),
                                      Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              TextButton(onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => EditPOSProduct(product: product,storeId: storeId,)),
                                                );
                                              }, child: Text('Edit',style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),),),
                                              TextButton(onPressed: (){
                                                functions.showDeletePOSProductDialog(context,'Delete Product','Are you Sure you want to delete this Product?',product['productID'] ?? '',storeId);
                                                setState(() {
                                                });
                                              }, child: Text('Delete',style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),),),
                                            ],
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CommonFunctions.commonSpace(height * 0.02, width),
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
      ),
    );
  }

  Future<String> getBranchIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? branchId = prefs.getString('branchId');
    return branchId ?? ''; // Return branchId if not null, otherwise return an empty string
  }
}
