import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExpiryFileHandleApi {
  static Future<String> saveDocument({
    required String name,
    required Uint8List bytes,
  }) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/$name';
    final file = File(filePath); // Create a File instance
    await file.writeAsBytes(bytes); // Write bytes to the file
    return filePath;
  }

  static Future<void> openExpiryFile(String filePath) async {
    // Use PlatformFile instead of File
    // final file = File(filePath);
    // if (await file.exists()) {
    //   print('Helum g');
    //   await file.open();
    //   print('Helum 2vg');
    //   // Open the file
    // }
    await OpenFile.open(filePath);
  }
}
