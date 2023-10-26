import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<void> downloadPDF(var pdf) async {
  final directory = await getApplicationDocumentsDirectory();
  final pdfFile = File('${directory.path}/example.pdf');
  // 将PDF内容写入文件
  await pdfFile.writeAsBytes(pdf);
}