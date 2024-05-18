
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pharmasage/Controller/Service/pdfApi.dart';
import 'package:pharmasage/Model/OrderInvoice/Vendor.dart';
import 'package:pharmasage/Model/TransactionInvoice/TransactionInvoice.dart';
import 'package:pharmasage/Utils/widgets/format.dart';
import '../../Model/OrderInvoice/Invoice.dart';
import '../../Model/OrderInvoice/Store.dart';
import '../../Model/TransactionInvoice/TransactionStore.dart';

class AppTransactionPdfInvoiceApi {
  static  Future<File> generate(TransactionInvoice invoice) async {
    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = Font.ttf(font);
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice,ttf),
        SizedBox(height: 1 * PdfPageFormat.cm),
        //buildTitle(invoice),
        buildInvoice(invoice,ttf),
        SizedBox(height: 1.5 * PdfPageFormat.cm),
        Divider(),
        buildTotal(invoice,ttf),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Divider(),
        Center(child: Text('Thanks for your Trust',style: TextStyle(font: ttf,fontSize: 20)),)
      ],
      //footer: (context) => buildFooter(invoice),
    ));
    return FileHandleApi.saveDocument(name: 'Invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(TransactionInvoice invoice,Font appFont) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildStoreInfo(invoice.store,appFont),
          // Container(
          //   height: 50,
          //   width: 50,
          //   child: BarcodeWidget(
          //     barcode: Barcode.qrCode(),
          //     data: invoice.info.number,
          //   ),
          // ),
        ],
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Transaction No:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.transactionId,style: TextStyle(font: appFont,fontSize: 20)),
            ],),
          //SizedBox(width: 0.5 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Order Date:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.transactionDate,style: TextStyle(font: appFont,fontSize: 20)),
            ],),
          //SizedBox(width: 0.5 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Order Time:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.transactionTime,style: TextStyle(font: appFont,fontSize: 20)),
            ],),


          // buildInvoiceInfo(invoice.info),
        ],
      ),
      //SizedBox(height: 1 * PdfPageFormat.cm),
      Divider(),
      //buildSupplierInfo(invoice.supplier,appFont),
    ],
  );

  static Widget buildSupplierInfo(Supplier supplier,Font appFont) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vendor Name:',style: TextStyle(font: appFont,fontSize: 20)),
          Text(supplier.name,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vendor Email:',style: TextStyle(font: appFont,fontSize: 20)),
          Text(supplier.email,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vendor Contact:',style: TextStyle(font: appFont,fontSize: 20)),
          Text(supplier.contact,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
    ],
  );

  static Widget buildStoreInfo(TransactionStore store,Font appFont) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(child:Text(store.name, style: TextStyle(fontWeight: FontWeight.bold,font: appFont,fontSize: 45)) ,),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Center(child:Text(store.address,style: TextStyle(font: appFont,fontSize: 20)),),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('License No:',style: TextStyle(font: appFont,fontSize: 20)),
          SizedBox(width: 1 * PdfPageFormat.mm),
          Text(store.licenseNo,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tel:',style: TextStyle(font: appFont,fontSize: 20)),
          SizedBox(width: 1 * PdfPageFormat.mm),
          Text(store.contact,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
    ],
  );

  //  static Widget buildTitle(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       'INVOICE',
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //     //Text(invoice.info.description),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //   ],
  // );

  static Widget buildInvoice(TransactionInvoice invoice,Font appFont) {
    final headers = [
      'Description',
      'Quantity',
      'Unit Price',
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity;

      return [
        item.description,
        //Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        //'${item.vat} %',
        //'\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold,font: appFont,fontSize: 20),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
      cellStyle: TextStyle(font: appFont, fontSize: 20),
    );
  }

  static Widget buildTotal(TransactionInvoice invoice,Font appFont) {
    final totalUnitPrices = invoice.items.map((item) => item.unitPrice).reduce((item1, item2) => item1 + item2);
    final delivery=invoice.info.tax;
    final total = totalUnitPrices + delivery;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Sub Total',
                  value: Utils.formatPrice(totalUnitPrices),
                  unite: true,
                ),
                buildText(
                  title: 'Tax',
                  value: Utils.formatPrice(delivery),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Net Total',
                  titleStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    font: appFont,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // static Widget buildFooter(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children: [
  //     Divider(),
  //     SizedBox(height: 2 * PdfPageFormat.mm),
  //     buildSimpleText(title: 'Address', value: invoice.supplier.address),
  //     SizedBox(height: 1 * PdfPageFormat.mm),
  //     buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //   ],
  // );
  //
  // static buildSimpleText({
  //   required String title,
  //   required String value,
  // }) {
  //   final style = TextStyle(fontWeight: FontWeight.bold);
  //
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //     children: [
  //       Text(title, style: style),
  //       SizedBox(width: 2 * PdfPageFormat.mm),
  //       Text(value),
  //     ],
  //   );
  // }
  //
  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    Font? appFont,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold,font: appFont,fontSize: 20);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style,)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}