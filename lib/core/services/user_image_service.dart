import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UserImageService {
  UserImageService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;
  final _uuid = const Uuid();

  Future<String?> pickAndSave({
    required ImageSlot slot,
    required int entityId,
    ImageSource source = ImageSource.gallery,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dir = await _uploadDir();
    final ext = p.extension(picked.path).isEmpty ? '.jpg' : p.extension(picked.path);
    final fileName = '${slot.name}_${entityId}_${_uuid.v4()}$ext';
    final dest = File(p.join(dir.path, fileName));
    await File(picked.path).copy(dest.path);
    return dest.path;
  }

  Future<Directory> _uploadDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'user_uploads'));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }
}

enum ImageSlot { coffeeHero, stepImage, recipeCover, methodCover }
