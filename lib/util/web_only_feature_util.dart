import 'dart:html';
import 'dart:typed_data';

Future<void> downloadPDF(var pdf) async {
  final blob = Blob([pdf]);
  final url = Url.createObjectUrlFromBlob(blob);
  final anchor = AnchorElement(href: url)
  ..target = 'webdownload'
  ..download = 'file.pdf' // 指定文件名
  ..click();
  Url.revokeObjectUrl(url);
}