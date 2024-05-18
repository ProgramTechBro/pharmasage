import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/InventoryProductDetail.dart';

import '../Utils/colors.dart';
class InventoryPage extends StatefulWidget {
  final String storeId;
  const InventoryPage({super.key,required this.storeId});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  TextEditingController searchController=TextEditingController();
  CommonFunctions common=CommonFunctions();
  String dropDownValue='All';
  String branchId='';
  String searchQuery = '';
  List<DocumentSnapshot>? productsData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    branchId=widget.storeId;
    fetchData();
  }
  Future<void> fetchData() async {
    if (branchId.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Inventory')
          .doc(branchId)
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
      if (dropDownValue == 'All' ||
          product['productCategory'] == dropDownValue) {
        String productName = product['productName'].toString().toUpperCase();
        if (productName.contains(searchQuery.toUpperCase())) {
          filteredList.add(product);
        }
      }
    }
    return filteredList;
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            children: [
              Container(
                height: height*0.15,
                width: width,
                //color: Colors.blue,
                child: Row(
                  children: [
                    Container(
                      height:height*0.07,
                        width: width*0.58,
                        child: TextField(
                          cursorColor: Colors.grey,
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Search by name',
                            labelStyle: textTheme.labelSmall!.copyWith(color: Colors.grey),
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
                            //contentPadding:
                            // EdgeInsets.symmetric(vertical: height * 0.034),
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
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: DropdownButton(
                          value: dropDownValue,
                          style: textTheme.labelSmall!.copyWith(color: Colors.grey),
                          underline: SizedBox(),
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: common.posCategories.map((String items) {
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
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.blue,
                height: height*0.8,
                child: Expanded(
                  child: productsData == null
                      ? Center(child: CircularProgressIndicator(color: primaryColor,))
                      : filteredData().isEmpty
                      ? Center(
                    child: Text('No products found for this category'),
                  )
                      : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two grid items in one row
                      crossAxisSpacing: width * 0.03, // Adjust spacing between grid items
                      mainAxisSpacing: height * 0.03, // Adjust spacing between rows
                    ),
                    itemCount: filteredData().length,
                    itemBuilder: (context, index) {
                      final product = filteredData()[index];
                      return GestureDetector(
                        onTap:(){
                          // final productSnapshot = InventoryProduct.fromMap(product.data() as Map<String, dynamic>);
                          // Provider.of<InventoryCartProvider>(context, listen: false).addProductToBilling(productSnapshot);
                        },
                        child: Container(
                          //height: height*0.2,
                          decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonFunctions.commonSpace(height*0.01,0),
                              Center(
                                child: Container(
                                  width: width * 0.38,
                                  height: height * 0.14,
                                  //padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white, // Set a background color if needed
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        product['productImage'] ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CommonFunctions.commonSpace(height*0.01,0),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product['productName'] ?? '',
                                          style: textTheme.labelSmall!.copyWith(color: Colors.black),
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.01),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => InventoryProductDetails(product: product)),
                                          );
                                        },
                                        child: Container(
                                          width: width * 0.08,
                                          height: height * 0.04,
                                          //padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white, // Set a background color if needed
                                          ),
                                          child: Center(
                                            child: Icon(Icons.arrow_forward_ios, color: Colors.black),

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
