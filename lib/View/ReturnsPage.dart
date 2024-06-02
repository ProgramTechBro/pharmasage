import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Controller/Service/ReturnInvoicepdf.dart';
import '../Controller/Service/ReturnpdfApi.dart';
import '../Model/ReturnInvoice/ReturnInvoice.dart';
import '../Model/ReturnInvoice/ReturnStore.dart';
import '../Utils/colors.dart';

class ReturnPage extends StatefulWidget {
  final String branchId;
  const ReturnPage({Key? key, required this.branchId}) : super(key: key);

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  late String returnId;
  late String returnDate;
  late String returnTime;
  late String againstInvoice;
  late double totalAmount;
  late String storeName;
  late String storeLocation;
  late String comment;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> orderStream = FirebaseFirestore.instance
        .collection('ReturnedTransactions')
        .doc(widget.branchId)
        .collection('ReturnID')
        .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: orderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final List<DocumentSnapshot> returnedTransactions = snapshot.data!.docs;

          // Filter orders based on vendorEmail
          final List<DocumentSnapshot> filteredOrders = returnedTransactions.where((returned) {
            returnId = returned['returnID'];
            returnDate=returned['returnDate'];
            returnTime=returned['returnTime'];
            againstInvoice=returned['returnAgainst'];
            //print('hooo $againstInvoice');
            totalAmount = (returned['totalAmount'] as int).toDouble();
            storeName=returned['storeName'];
            storeLocation=returned['storeLocation'];
            comment=returned['comment'];
            return true;
          }).toList();
          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final orderData = filteredOrders[index].data() as Map<String, dynamic>;
              print(orderData['againstInvoice']);

              return InkWell(
                onTap: () async {
                  final productData = orderData['selectedProducts'];
                  print(productData);
                  final List<ReturnInvoiceItem> items = productData.map<ReturnInvoiceItem>((product) {
                    return ReturnInvoiceItem(
                      description: product['productName'],
                      quantity: product['productQuantity'],
                      unitPrice: (product['returnProductPrice'] as int).toDouble() ,
                    );
                  }).toList();
                  print('Good time');
                  final invoice = ReturnInvoice(
                    store: ReturnStore(
                      name: storeName,
                      address: storeLocation,
                      licenseNo: '3OB8-87654332',
                      contact: '0321-7655433',
                    ),
                    info: ReturnInvoiceInfo(
                      returnId: returnId,
                      returnDate: returnDate,
                      returnTime: returnTime,
                      againstInvoice: againstInvoice,
                      comment:comment,
                    ),
                    items: items,
                  );
                  print('hello');
                  final pdfFile = await ReturnPdfInvoiceApi.generate(invoice);
                  print('hello');
                  ReturnFileHandleApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                  child: Card(
                    color: grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      height: height * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Return ID : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500, color: white)),
                                  TextSpan(text: orderData['returnID'], style: textTheme.bodySmall!.copyWith(color: white)),
                                ]),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'Return Date : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                    TextSpan(text: orderData['returnDate'], style: textTheme.bodySmall),
                                  ]),
                                ),
                                SizedBox(height: height * 0.01, width: 0),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'Return Time : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                    TextSpan(text: orderData['returnTime'], style: textTheme.bodySmall),
                                  ]),
                                ),
                                SizedBox(height: height * 0.01),
                                Center(child: const Text('- - - - - - - - - - - - - - - - - - - -', style: TextStyle(fontSize: 20))),
                                SizedBox(height: height * 0.01),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'Return Against : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                    TextSpan(text: orderData['returnAgainst'], style: textTheme.bodySmall),
                                  ]),
                                ),
                                SizedBox(height: height * 0.02),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: 'total Amount : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                    TextSpan(text: orderData['totalAmount'].toString(), style: textTheme.bodySmall),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
