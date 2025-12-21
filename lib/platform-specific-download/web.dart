import 'dart:html' as html;
import 'dart:typed_data';
void platformspecexcel(bytes,name)async{
  final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "${name}.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
}

  