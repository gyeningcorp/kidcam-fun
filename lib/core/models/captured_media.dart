/// Metadata for a captured photo stored in the local media index.
class CapturedMedia {
  /// Unique identifier (UUID v4).
  final String id;

  /// Filename within the KidCamPhotos directory.
  final String filename;

  /// ID of the filter that was active when the photo was taken.
  final String filterId;

  /// When the photo was captured.
  final DateTime capturedAt;

  /// File size in bytes for storage management.
  final int fileSizeBytes;

  const CapturedMedia({
    required this.id,
    required this.filename,
    required this.filterId,
    required this.capturedAt,
    required this.fileSizeBytes,
  });

  /// Create from SQLite row.
  factory CapturedMedia.fromMap(Map<String, dynamic> map) {
    return CapturedMedia(
      id: map['id'] as String,
      filename: map['filename'] as String,
      filterId: map['filter_id'] as String,
      capturedAt: DateTime.fromMillisecondsSinceEpoch(map['captured_at'] as int),
      fileSizeBytes: map['file_size_bytes'] as int,
    );
  }

  /// Convert to SQLite row.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filename': filename,
      'filter_id': filterId,
      'captured_at': capturedAt.millisecondsSinceEpoch,
      'file_size_bytes': fileSizeBytes,
    };
  }

  @override
  String toString() =>
      'CapturedMedia(id: $id, filename: $filename, filter: $filterId)';
}
