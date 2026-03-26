import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

/// Manages local photo storage in the app-private sandbox.
///
/// Photos are always saved to the app sandbox (no permission needed).
/// Exporting to the device photo library requires the parent to enable
/// the setting AND system-level photo library permission.
class LocalStorageService {
  static const _photoDir = 'KidCamPhotos';

  /// Get the app-private directory for photos.
  Future<Directory> _getPhotoDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${appDir.path}/$_photoDir');
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }
    return photoDir;
  }

  /// Save photo to app sandbox (always allowed, no permission needed).
  Future<File> saveToAppSandbox(
    List<int> imageBytes,
    String filename,
  ) async {
    final dir = await _getPhotoDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file;
  }

  /// Save to device photo library.
  ///
  /// Requires BOTH:
  /// 1. Parent has enabled saving in app settings
  /// 2. System photo library permission is granted
  Future<bool> saveToPhotoLibrary(
    List<int> imageBytes, {
    required bool parentHasEnabledSaving,
  }) async {
    if (!parentHasEnabledSaving) {
      return false; // Silent fail — child should never reach this code path
    }

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(imageBytes),
      name: 'KidCamFun_${DateTime.now().millisecondsSinceEpoch}',
    );
    return result['isSuccess'] == true;
  }

  /// List all photos in the app sandbox, sorted newest first.
  Future<List<File>> listPhotos() async {
    final dir = await _getPhotoDirectory();
    if (!await dir.exists()) return [];

    final files = await dir.list().toList();
    return files.whereType<File>().toList()
      ..sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );
  }

  /// Total storage used by saved photos in bytes.
  Future<int> totalStorageBytes() async {
    final photos = await listPhotos();
    var total = 0;
    for (final file in photos) {
      total += await file.length();
    }
    return total;
  }

  /// Delete ALL saved photos. Parent gate must be verified before calling.
  Future<void> clearAllPhotos() async {
    final dir = await _getPhotoDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}

/// Riverpod provider for local storage.
final localStorageProvider = Provider<LocalStorageService>(
  (_) => LocalStorageService(),
);
