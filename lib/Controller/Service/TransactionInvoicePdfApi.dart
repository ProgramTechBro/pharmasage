import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../Model/TransactionInvoice/TransactionInvoice.dart';
import 'TransactionPdfApi.dart';

class TransactionPdfInvoiceApi {
  static Future<Uint8List> generate(TransactionInvoice invoice) async {
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final PdfDocument pdf = PdfDocument();
    final page = pdf.pages.add();

    _drawContent(page, invoice);

    final bytes = await TransactionFileHandleApi.saveDocument(
      name: 'TransactionInvoice.pdf',
      document: pdf,
    );
    return bytes;
  }

  static void _drawContent(PdfPage page, TransactionInvoice invoice) {
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
    graphics.drawString('Transaction No: ${invoice.info.transactionId}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('Transaction Date: ${invoice.info.transactionDate}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(bounds.width / 3, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    graphics.drawString('Transaction Time: ${invoice.info.transactionTime}',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(2 * bounds.width / 3, 120, bounds.width / 3, 20),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    ///////////////////////////////////////////////////////////
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold); // Bold font
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);

// Add table headers and set their font style
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Description';
    headerRow.cells[1].value = 'Quantity';
    headerRow.cells[2].value = 'Unit Price';

// Set the font style for table headers
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.font = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    }

// Draw table rows
    for (int i = 0; i < invoice.items.length; i++) {
      final item = invoice.items[i];
      final row = grid.rows.add();
      row.cells[0].value = item.description;
      row.cells[1].value = '${item.quantity}';
      final total = item.unitPrice * item.quantity;
      row.cells[2].value = '\$ $total';
      totalPrice += total;
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
    final totalUnitPrices = totalPrice;
    final delivery = invoice.info.tax;
    final total = totalUnitPrices + delivery;

    graphics.drawString('Sub Total: \$${totalUnitPrices.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, bounds.height - 500, bounds.width, 20), // Adjusted Y position and width
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align

// Draw Tax
    graphics.drawString('Tax included: \$${delivery.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, bounds.height - 480, bounds.width, 20), // Adjusted Y position
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align

// Draw Net Total
    graphics.drawString('Net Total: \$${total.toStringAsFixed(2)}', PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: Rect.fromLTWH(0, bounds.height - 460, bounds.width, 20), // Adjusted Y position
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle)); // Right align
    final String thankYouText = "Thanks for your Trust";
    final Size textSize = font.measureString(thankYouText);

    final double textX = (bounds.width - textSize.width) / 2;
    final double textY = (bounds.height - textSize.height) / 2 - 40; // Move up by 40 units
    graphics.drawString(
      thankYouText,
      font,
      bounds: Rect.fromLTWH(textX, textY, textSize.width, textSize.height),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

}
