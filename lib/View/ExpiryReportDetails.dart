import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Model/MedicalStore/MedicalStore.dart';

import '../Controller/Service/ExpiryReportApi.dart';
import '../Controller/Service/ExpiryReportpdf.dart';
import '../Controller/Service/TransactionPdfApi.dart';
import '../Model/ExpiryReport/ExpiryReport.dart';
import '../Model/ExpiryReport/ExpiryStore.dart';
import '../Model/POS/POSProduct.dart';
import '../Utils/colors.dart';

class ExpiryReportDetails extends StatefulWidget {
  final List<InventoryProduct> products;
  final String storeId;
  const ExpiryReportDetails({Key? key, required this.products,required this.storeId}) : super(key: key);

  @override
  State<ExpiryReportDetails> createState() => _ExpiryReportDetailsState();
}

class _ExpiryReportDetailsState extends State<ExpiryReportDetails> {
  bool isExpiryOpening=false;
  MedicalStore store=MedicalStore();
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
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Expiry Products',
            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height * 0.02, 0),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: height * 0.01);
                  },
                  itemBuilder: (context, index) {
                    final productData = widget.products[index];
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: Card(
                        color: grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Product ID : ',
                                    style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: productData.productID, style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              const Text(
                                '- - - - - - - - - - - - - - - - - - -',
                                style: TextStyle(fontSize: 20),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Product Name: ',
                                    style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: productData.productName, style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Product Category: ',
                                    style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: productData.productCategory, style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Cost Price: ',
                                    style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: productData.costPrice.toString(), style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Expiry Date : ',
                                    style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: productData.productExpiry, style: textTheme.bodySmall),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CommonFunctions.commonSpace(height * 0.03, 0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      minimumSize: Size(width * 0.5, height * 0.08),
                    ),
                    onPressed: ()async {
                      setState(() {
                        isExpiryOpening=true;
                      });
                      Map<String, dynamic> storeData = await fetchStoreData(widget.storeId);
                      store = MedicalStore.fromMap(storeData);
                      int length=widget.products.length;
                      String currentDate=getCurrentDateFormatted();
                      String currentTime=getCurrentTimeFormatted();
                      List<InventoryProduct> reportProducts=widget.products;
                      final List<ExpiryInvoiceItem> items = reportProducts.map<ExpiryInvoiceItem>((product) {
                        return ExpiryInvoiceItem(
                          expiryProductId: product.productID!,
                          description: product.productName!,
                          Category: product.productCategory!,
                          costPrice: product.costPrice!,
                          expiryDate: product.productExpiry!,
                        );
                      }).toList();
                      final invoice = ExpiryInvoice(
                        store: ExpiryStore(
                          name: store.branchName!,
                          address: store.branchLocation!,
                          licenseNo: '3OB8-87654332',
                          contact: '0321-7655433',
                        ),
                        info: ExpiryInvoiceInfo(
                          expireNo: length,
                          currentDate: currentDate,
                          currentTime: currentTime,
                        ),
                        items: items,
                      );
                      print('hello');
                      setState(() {
                        isExpiryOpening=false;
                      });
                      final pdfFile = await ExpiryPdfInvoiceApi.generate(invoice);
                      final filePath = await ExpiryFileHandleApi.saveDocument(
                        name: 'ExpiryReport.pdf',
                        bytes: pdfFile,
                      );
                      if (filePath != null && filePath.isNotEmpty) {
                        print('PDF file downloaded successfully at: $filePath');
                      } else {
                        print('Error: File path is empty or null');
                      }
                      await ExpiryFileHandleApi.openExpiryFile(filePath);
                    },
                    child: isExpiryOpening ?CircularProgressIndicator(color: Colors.white,):Text(
                      'Download Report',
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
}
