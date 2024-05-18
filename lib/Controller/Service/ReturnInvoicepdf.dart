
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pharmasage/Controller/Service/pdfApi.dart';
import 'package:pharmasage/Model/OrderInvoice/Vendor.dart';
import 'package:pharmasage/Utils/widgets/format.dart';
import '../../Model/OrderInvoice/Invoice.dart';
import '../../Model/OrderInvoice/Store.dart';
import '../../Model/ReturnInvoice/ReturnInvoice.dart';
import '../../Model/ReturnInvoice/ReturnStore.dart';

class ReturnPdfInvoiceApi {
  static  Future<File> generate(ReturnInvoice invoice) async {
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
        buildLastComment(invoice, ttf),
        Divider(),
      ],
      //footer: (context) => buildFooter(invoice),
    ));
    return FileHandleApi.saveDocument(name: 'ReturnInvoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(ReturnInvoice invoice,Font appFont) => Column(
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
              Text('Return ID:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.returnId,style: TextStyle(font: appFont,fontSize: 20)),
            ],),
          //SizedBox(width: 0.5 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Order Date:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.returnDate,style: TextStyle(font: appFont,fontSize: 20)),
            ],),
          //SizedBox(width: 0.5 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Order Time:',style: TextStyle(font: appFont,fontSize: 20)),
              Text(invoice.info.returnTime,style: TextStyle(font: appFont,fontSize: 20)),
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

  static Widget buildStoreInfo(ReturnStore store,Font appFont) => Column(
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

   static Widget buildLastComment(ReturnInvoice invoice,Font appFont) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Text(invoice.info.description),
      SizedBox(height: 0.1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Comment: ',style: TextStyle(font: appFont,fontSize: 20)),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(invoice.info.comment,style: TextStyle(font: appFont,fontSize: 20)),
        ],),
    ],
  );

  static Widget buildInvoice(ReturnInvoice invoice,Font appFont) {
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

  static Widget buildTotal(ReturnInvoice invoice,Font appFont) {
    final totalUnitPrices = invoice.items.map((item) => item.unitPrice).reduce((item1, item2) => item1 + item2);
    final comment=invoice.info.comment;
    final returnAgainst=invoice.info.againstInvoice;
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 1 * PdfPageFormat.mm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Returned Against: ',style: TextStyle(font: appFont,fontSize: 20,fontWeight:FontWeight.bold)),
              SizedBox(width: 2 * PdfPageFormat.mm),
              Text(returnAgainst,style: TextStyle(font: appFont,fontSize: 20)),
            ],),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Total Amount: ',style: TextStyle(font: appFont,fontSize: 20,fontWeight:FontWeight.bold)),
              SizedBox(width: 2 * PdfPageFormat.mm),
              Text(totalUnitPrices.toString(),style: TextStyle(font: appFont,fontSize: 20)),
            ],),
        ]
      )
    );
    // return Container(
    //   alignment: Alignment.centerRight,
    //   child: Row(
    //     children: [
    //       Spacer(flex: 6),
    //       Expanded(
    //         flex: 4,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             buildText(
    //               title: 'Return Against',
    //               value: returnAgainst,
    //               unite: true,
    //             ),
    //             buildText(
    //               title: 'Total Amount',
    //               value: Utils.formatPrice(totalUnitPrices),
    //               unite: true,
    //             ),
    //             Divider(),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text('Comment:',style: TextStyle(font: appFont,fontSize: 20)),
    //                 SizedBox(width: 1 * PdfPageFormat.mm),
    //                 Text(comment,style: TextStyle(font: appFont,fontSize: 20)),
    //               ],),
    //             SizedBox(height: 2 * PdfPageFormat.mm),
    //             Container(height: 1, color: PdfColors.grey400),
    //             SizedBox(height: 0.5 * PdfPageFormat.mm),
    //             Container(height: 1, color: PdfColors.grey400),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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