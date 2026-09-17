import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'user_image_io.dart' if (dart.library.html) 'user_image_web.dart' as io;

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

    if (kIsWeb) {
      // Blob URLs work for the current session; persist path string for overrides.
      return picked.path;
    }

    final bytes = await picked.readAsBytes();
    final base = await getApplicationDocumentsDirectory();
    final dirPath = p.join(base.path, 'user_uploads');
    await io.ensureDir(dirPath);
    final ext = p.extension(picked.name).isEmpty ? '.jpg' : p.extension(picked.name);
    final fileName = '${slot.name}_${entityId}_${_uuid.v4()}$ext';
    final dest = p.join(dirPath, fileName);
    await io.writeBytes(dest, bytes);
    return dest;
  }
}

enum ImageSlot { coffeeHero, stepImage, recipeCover, methodCover }
