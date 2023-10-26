import 'dart:html';

//只有網頁板可以執行的命令寫這裡
//網頁版專用，手機板導入html會崩潰
Future<void> downloadPDF(var pdf) async {
  final blob = Blob([pdf]);
  final url = Url.createObjectUrlFromBlob(blob);
  final anchor = AnchorElement(href: url)
  ..target = 'webdownload'
  ..download = 'file.pdf' // 指定文件名
  ..click();
  Url.revokeObjectUrl(url);
}