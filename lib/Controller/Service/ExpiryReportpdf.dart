import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pharmasage/Model/ExpiryReport/ExpiryReport.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../Model/TransactionInvoice/TransactionInvoice.dart';
import 'ExpiryReportApi.dart';
import 'TransactionPdfApi.dart';

class ExpiryPdfInvoiceApi {
  static Future<Uint8List> generate(ExpiryInvoice invoice) async {
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final PdfDocument pdf = PdfDocument();
    final page = pdf.pages.add();

    _drawContent(page, invoice);

    final List<int> bytes = await pdf.save(); // Save the PDF document
    return Uint8List.fromList(bytes);
  }


  static void _drawContent(PdfPage page, ExpiryInvoice invoice) {
    final bounds = page.getClientSize();
    final graphics = page.graphics;
    double totalPrice=0.0;

    // Draw store information
    graphics.drawString(
        invoice.store.name, PdfStandardFont(PdfFontFamily.helvetica, 24),
        bounds: Rect.fromLTWH(0, 20, bounds.width, 30),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString(
        invoice.store.address, PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, 50, bounds.width, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('License No: ${invoice.store.licenseNo}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, 70, bounds.width, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('Tel: ${invoice.store.contact}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, 90, bounds.width, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    // Draw transaction information
    graphics.drawString('Expiry Product: ${invoice.info.expireNo}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('Current Date: ${invoice.info.currentDate}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(bounds.width / 3, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('Current Time: ${invoice.info.currentTime}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(2 * bounds.width / 3, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    ///////////////////////////////////////////////////////////
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold); // Bold font
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

// Add table headers and set their font style
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Product ID';
    headerRow.cells[1].value = 'Name';
    headerRow.cells[2].value = 'Category';
    headerRow.cells[3].value = 'Price';
    headerRow.cells[4].value = 'ExpiryDate';
// Set the font style for table headers
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.font = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    }

// Draw table rows
    for (int i = 0; i < invoice.items.length; i++) {
      final item = invoice.items[i];
      final row = grid.rows.add();
      row.cells[0].value = item.expiryProductId;
      row.cells[1].value = item.description;
      row.cells[2].value = item.Category;
      row.cells[3].value = '\$ ${item.costPrice}';
      row.cells[4].value = item.expiryDate;
      // Set the font size for the table rows
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style.font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      }
    }

// Set layout format
    final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

// Draw grid
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 170, bounds.width, bounds.height - 400), // Adjusted height and position
      format: layoutFormat,
    );

    // Draw total
//     final totalUnitPrices = totalPrice;
//     final delivery = invoice.info.tax;
//     final total = totalUnitPrices + delivery;
//
//     graphics.drawString('Sub Total: \$${totalUnitPrices.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
//         bounds: Rect.fromLTWH(0, bounds.height - 500, bounds.width, 20), // Adjusted Y position and width
//         format: PdfStringFormat(
//             alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align
//
// // Draw Tax
//     graphics.drawString('Tax included: \$${delivery.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
//         bounds: Rect.fromLTWH(0, bounds.height - 480, bounds.width, 20), // Adjusted Y position
//         format: PdfStringFormat(
//             alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align
//
// // Draw Net Total
//     graphics.drawString('Net Total: \$${total.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
//         bounds: Rect.fromLTWH(0, bounds.height - 460, bounds.width, 20), // Adjusted Y position
//         format: PdfStringFormat(
//             alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align
//     final String thankYouText = "Stay tuned for more expiry product updates!";
//     // final Size textSize = font.measureString(thankYouText);
//     //
//     // final double textX = (bounds.width - textSize.width) / 2;
//     // final double textY = (bounds.height - textSize.height) / 2 - 40; // Move up by 40 units
//     // graphics.drawString(
//     //   thankYouText,
//     //   font,
//     //   bounds: Rect.fromLTWH(textX, textY, textSize.width, textSize.height),
//     //   format: PdfStringFormat(
//     //     alignment: PdfTextAlignment.center,
//     //     lineAlignment: PdfVerticalAlignment.middle,
//     //   ),
//     // );
  }

}
