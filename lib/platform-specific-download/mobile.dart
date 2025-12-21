import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

void platformspecexcel(bytes, name) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name');
  await file.writeAsBytes(bytes, flush: true);
}