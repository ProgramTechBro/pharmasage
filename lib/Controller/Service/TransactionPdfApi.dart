import 'dart:typed_data';
import 'dart:html' as html;
import 'package:syncfusion_flutter_pdf/pdf.dart';
class TransactionFileHandleApi {
  static Future<Uint8List> saveDocument({
    required String name,
    required PdfDocument document,
  }) async {
    final bytes = await document.save();
    return Uint8List.fromList(bytes);
  }

  static Future<void> openFile(Uint8List bytes, String name) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

