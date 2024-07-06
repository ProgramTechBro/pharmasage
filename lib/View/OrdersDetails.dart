import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Service/Invoicepdf.dart';
import '../Controller/Service/pdfApi.dart';
import '../Model/OrderInvoice/Invoice.dart';
import '../Model/OrderInvoice/Store.dart';
import '../Model/OrderInvoice/Vendor.dart';
import '../Utils/colors.dart';

OrderController controller = OrderController();

class OrdersDetails extends StatefulWidget {
  final String storeId;
  const OrdersDetails({Key? key, required this.storeId});

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  late var selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Pending',
    'Completed',
    'Accepted',
    'Rejected',
  ];
  late List<Map<String, dynamic>> orders = []; // Stores the fetched orders
  late List<bool> isOrderCompleting = []; // Track completion status for each order
  bool isLoading = true; // Track whether data is loading

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget initializes
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true; // Start loading indicator
    });

    try {
      // Fetch orders from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('storeId', isEqualTo: widget.storeId)
          .get();

      setState(() {
        orders = querySnapshot.docs.map((doc) => doc.data()).toList();
        isOrderCompleting = List<bool>.filled(orders.length, false);
        isLoading = false; // Stop loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator on error
      });
      print('Error fetching orders: $e');
      // Handle error or show a message
    }
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

  List<Map<String, dynamic>> filterOrdersByCategory(String category) {
    // Filter orders based on selected category
    if (category == 'All') {
      return orders;
    } else {
      return orders.where((order) => order['orderStatus'] == category).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<AdminProvider>(context);
    final filteredOrders = filterOrdersByCategory(selectedCategory);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height * 0.02, 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: height * 0.065,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                          },
                          child: Container(
                            width: width * 0.4,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(color: grey, width: 6),
                              color: selectedCategory == categories[index] ? grey : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height * 0.03, 0),
                Container(
                  height: height * 0.75, // Adjust the height as needed
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.02),
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                      : orders.isEmpty
                      ? Center(
                    child: Text('No orders for this store',style: textTheme.labelLarge,),
                  )
                      : filteredOrders.isEmpty
                      ? Center(
                    child: filteredOrders.isNotEmpty
                        ? CircularProgressIndicator(color: primaryColor)
                        : Text('No $selectedCategory orders',style: textTheme.labelLarge,),
                  ):ListView.separated(
                    itemCount: filteredOrders.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: height * 0.02); // Adjust the height as needed
                    },
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return InkWell(
                        onTap: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const storeDashboard()));
                        },
                        child: Card(
                          color: grey,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            height: height * 0.37,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      order['orderStatus'],
                                      style: textTheme.displaySmall!
                                          .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                CommonFunctions.commonSpace(height * 0.01, 0),
                                Container(
                                  padding:
                                  EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.04),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Order ID : ',
                                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                              TextSpan(text: order['orderID'], style: textTheme.bodySmall),
                                            ]),
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Status : ',
                                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                              TextSpan(text: order['orderStatus'], style: textTheme.bodySmall),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: const Text(
                                          '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: 'Order Date : ',
                                              style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                          TextSpan(text: order['orderDate'], style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: 'Order Time : ',
                                              style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                          TextSpan(text: order['orderTime'], style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: 'Amount : ',
                                              style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                          TextSpan(text: order['totalAmount'].toString(), style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.02, 0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          provider.role == 'Branch Manager'
                                              ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(35)),
                                              minimumSize: Size(width * 0.2, height * 0.06),
                                            ),
                                            onPressed: isOrderCompleting[index]
                                                ? null // Disable button when completing
                                                : () async {
                                              if (order['orderStatus'] != 'Completed') {
                                                setState(() {
                                                  isOrderCompleting[index] = true; // Mark as completing
                                                });
                                                await controller.completeOrder(order['orderID']);
                                                CommonFunctions.showSuccessToast(
                                                    context: context, message: 'Order Completed');
                                                setState(() {
                                                  isOrderCompleting[index] = false; // Mark as completed
                                                });
                                                // Reload the orders to reflect changes
                                                await fetchOrders();
                                              }
                                            },
                                            child: isOrderCompleting[index]
                                                ? const CircularProgressIndicator(color: Colors.white)
                                                : Text(
                                              'Mark Complete',
                                              style: textTheme.labelLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                              : Container(),
                                          InkWell(
                                            onTap: () async {
                                              final store = await fetchStoreData(order['storeId']);
                                              final productData = order['orderedProducts'];
                                              final List<InvoiceItem> items =
                                              productData.map<InvoiceItem>((product) {
                                                return InvoiceItem(
                                                  description: product['productName'],
                                                  quantity: product['quantity'],
                                                  unitPrice: product['productPrice'],
                                                );
                                              }).toList();
                                              final invoice = Invoice(
                                                supplier: Supplier(
                                                  name: order['vendorName'],
                                                  email: order['vendorEmail'],
                                                  contact: order['vendorContact'],
                                                ),
                                                store: Store(
                                                  name: store['branchName'],
                                                  address: store['branchLocation'],
                                                  licenseNo: '3OB8-87654332',
                                                  contact: '0321-7655433',
                                                ),
                                                info: InvoiceInfo(
                                                  orderId: order['orderID'],
                                                  orderDate: order['orderDate'],
                                                  orderTime: order['orderTime'],
                                                  orderStatus: order['orderStatus'],
                                                  delivery: 200,
                                                ),
                                                items: items,
                                              );
                                              final pdfFile = await PdfInvoiceApi.generate(invoice);
                                              FileHandleApi.openFile(pdfFile);
                                            },
                                            child: Container(
                                              height: height * 0.06,
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(Icons.print, size: 20),
                                                  Text('Invoice',
                                                      style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
