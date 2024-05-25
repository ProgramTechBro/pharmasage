import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/POSController.dart';
import 'package:pharmasage/Controller/Provider/POSProvider.dart';
import 'package:pharmasage/Model/Transaction/TransactionDetails.dart';
import 'package:pharmasage/Model/TransactionInvoice/TransactionInvoice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Service/TransactionInvoicePdfApi.dart';
import '../../Controller/Service/TransactionPdfApi.dart';
import '../../Controller/Service/pdfApi.dart';
import '../../Model/POS/POSProduct.dart';
import '../../Model/TransactionInvoice/TransactionStore.dart';
import '../../Utils/colors.dart';
import '../../Utils/widgets/InputTextFiellds.dart';
class InvoicePage extends StatefulWidget {
  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  TextEditingController invoiceSearchController=TextEditingController();
  TransactionModel transactionModel=TransactionModel();
  bool isSearchingInvoice=false;
  onPressed()async{
    setState(() {
      isSearchingInvoice=true;
    });
    String storeId=await getBranchIdFromSharedPreferences();
    print('Store ID $storeId');
    String invoiceNO=invoiceSearchController.text;
    print('Invoice No $invoiceNO');
    transactionModel=(await POSController.fetchTransactionById(storeId: storeId, transactionId: invoiceNO))!;
    String storeName=transactionModel.storeName!;
    String storeLocation=transactionModel.storeLocation!;
    String tId=transactionModel.transactionID!;
    String tDate=transactionModel.transactionDate!;
    String tTime=transactionModel.transactionTime!;
    double tax=transactionModel.tax!;
    final List<InventoryProduct> selectedProducts = transactionModel.selectedProducts!;

    // Create InvoiceItem list from selected products
    final List<TransactionInvoiceItem> items = selectedProducts.map<TransactionInvoiceItem>((product) {
      return TransactionInvoiceItem(
        description: product.productName!,
        quantity: product.productQuantity!,
        unitPrice: product.sellingPrice!,
      );
    }).toList();
    final invoice = TransactionInvoice(
      store: TransactionStore(
        name: storeName,
        address: storeLocation,
        licenseNo: '3OB8-87654332',
        contact: '0321-7655433',
      ),
      info: TransactionInvoiceInfo(
        transactionId: tId,
        transactionDate: tDate,
        transactionTime: tTime,
        tax: tax,
      ),
      items: items,
    );
    setState(() {
      isSearchingInvoice=false;
    });
    print('hello');
    final Uint8List pdfFile = await TransactionPdfInvoiceApi.generate(invoice);
    await TransactionFileHandleApi.openFile(pdfFile, 'TransactionInvoice.pdf');

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
          height:height*0.6,
          width: width*0.6,
          //color: Colors.blue,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
                    'Search Invoice',
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height*0.1, 0),
              Container(
                height: height*0.3,
                width: width*0.4,
                padding: EdgeInsets.symmetric(horizontal: width*0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invoice Number',style: textTheme.bodyMedium),
                    CommonFunctions.commonSpace(height*0.02, 0),
                    InputTextFieldSeller( controller:invoiceSearchController,title: 'Enter Invoice Number', textTheme: textTheme,),
                    CommonFunctions.commonSpace(height*0.04, 0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          minimumSize: Size(width*0.1, height * 0.08),
                        ),
                        onPressed: onPressed,
                        child: isSearchingInvoice?CircularProgressIndicator(color: Colors.white,):Text(
                          'Search',
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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