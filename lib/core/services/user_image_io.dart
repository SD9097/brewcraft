import 'dart:io';
import 'dart:typed_data';

Future<void> ensureDir(String path) async {
  final dir = Directory(path);
  if (!dir.existsSync()) await dir.create(recursive: true);
}

Future<void> writeBytes(String path, Uint8List bytes) async {
  await File(path).writeAsBytes(bytes, flush: true);
}
