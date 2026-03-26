import 'package:flutter/material.dart';

/// Category for filter availability.
enum FilterCategory { free, premium }

/// Where a filter layer should be anchored on the face.
class FilterAnchor {
  /// Landmark type: 'nose', 'leftEye', 'rightEye', 'mouth', 'topHead', 'face_center'
  final String landmarkType;

  /// Relative offset from anchor point (in face-width units).
  final Offset offset;

  const FilterAnchor({required this.landmarkType, this.offset = Offset.zero});
}

/// A single visual layer of a filter (e.g., ears, whiskers, nose are separate layers).
class FilterLayer {
  /// Path to the PNG asset in assets/filters/
  final String imageAsset;

  /// Where this layer anchors to the face.
  final FilterAnchor anchor;

  /// Width as a ratio of the face bounding box width.
  final double widthRatio;

  /// Height as a ratio of the layer's width (aspect ratio).
  final double heightRatio;

  /// Fine-tune placement offset (in face-width units).
  final Offset centerOffset;

  const FilterLayer({
    required this.imageAsset,
    required this.anchor,
    required this.widthRatio,
    this.heightRatio = 1.0,
    this.centerOffset = Offset.zero,
  });
}

/// An effect triggered by facial expressions (e.g., smile triggers stars).
class ExpressionEffect {
  /// Effect type identifier: 'smile_stars', 'wink_sparkle', 'mouth_open_roar'
  final String type;

  /// Sound to play when the effect triggers.
  final String soundAsset;

  const ExpressionEffect({required this.type, required this.soundAsset});
}

/// Complete definition of a face filter.
class FilterDefinition {
  /// Unique identifier for this filter.
  final String id;

  /// Display name shown in the carousel.
  final String displayName;

  /// Emoji shown in filter selector thumbnail.
  final String emoji;

  /// Path to thumbnail image asset.
  final String thumbnailAsset;

  /// Ordered list of visual layers composited onto the face.
  final List<FilterLayer> layers;

  /// Whether this filter is free or premium.
  final FilterCategory category;

  /// Sound effect played when this filter is selected.
  final String? triggerSound;

  /// Optional expression-triggered effect.
  final ExpressionEffect? expressionEffect;

  const FilterDefinition({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.thumbnailAsset,
    required this.layers,
    this.category = FilterCategory.free,
    this.triggerSound,
    this.expressionEffect,
  });
}
