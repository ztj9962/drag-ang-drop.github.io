import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

//手機專用下載函數
Future<void> downloadPDF(var pdf) async {
  final directory = await getApplicationDocumentsDirectory();
  final pdfFile = File('${directory.path}/example.pdf');
  await pdfFile.writeAsBytes(pdf);
}