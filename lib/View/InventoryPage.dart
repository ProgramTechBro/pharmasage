import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/InventoryProductDetail.dart';

import '../Utils/colors.dart';

class InventoryPage extends StatefulWidget {
  final String storeId;

  const InventoryPage({Key? key, required this.storeId}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  TextEditingController searchController = TextEditingController();
  String dropDownValue = 'All';
  String branchId = '';
  String searchQuery = '';
  List<DocumentSnapshot>? productsData;

  @override
  void initState() {
    super.initState();
    branchId = widget.storeId;
    fetchData();
  }

  Future<void> fetchData() async {
    if (branchId.isNotEmpty) {
      setState(() {
        productsData = null; // Reset products data before fetching
      });

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Inventory')
            .doc(branchId)
            .collection('Products')
            .get();

        setState(() {
          productsData = querySnapshot.docs;
        });
      } catch (e) {
        print('Error fetching inventory data: $e');
        setState(() {
          productsData = []; // Set productsData to empty list on error
        });
      }
    }
  }

  List<DocumentSnapshot> filteredData() {
    if (productsData == null) return [];
    List<DocumentSnapshot> filteredList = [];
    // Apply filters based on search query and dropdown selection
    for (DocumentSnapshot product in productsData!) {
      if (dropDownValue == 'All' ||
          product['productCategory'] == dropDownValue) {
        String productName =
        product['productName'].toString().toUpperCase();
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
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            children: [
              Container(
                height: height * 0.15,
                width: width,
                child: Row(
                  children: [
                    Container(
                      height: height * 0.07,
                      width: width * 0.58,
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search by name',
                          labelStyle: textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
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
                          items: CommonFunctions().posCategories
                              .map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style:
                                TextStyle(color: Colors.grey.shade600),
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
                height: height * 0.8,
                child: productsData == null
                    ? Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
                    : productsData!.isEmpty
                    ? Center(
                  child: Text('No Inventory Data for this store',style: textTheme.labelLarge,),
                )
                    : GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.03,
                    mainAxisSpacing: height * 0.03,
                  ),
                  itemCount: filteredData().length,
                  itemBuilder: (context, index) {
                    final product = filteredData()[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InventoryProductDetails(
                                      product: product)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CommonFunctions.commonSpace(
                                height * 0.01, 0),
                            Center(
                              child: Container(
                                width: width * 0.38,
                                height: height * 0.14,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Image.network(
                                      product['productImage'] ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CommonFunctions.commonSpace(
                                height * 0.01, 0),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product['productName'] ?? '',
                                        style: textTheme.labelSmall!
                                            .copyWith(
                                            color: Colors.black),
                                      ),
                                    ),
                                    CommonFunctions.commonSpace(
                                        0, width * 0.01),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InventoryProductDetails(
                                                      product:
                                                      product)),
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.08,
                                        height: height * 0.04,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              30),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
