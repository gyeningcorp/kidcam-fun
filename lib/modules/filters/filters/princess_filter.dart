import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const princessFilter = FilterDefinition(
  id: 'princess',
  displayName: 'Princess',
  emoji: '\u{1F451}',
  thumbnailAsset: 'assets/filters/princess_crown.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Tiara/crown on top of head
    FilterLayer(
      imageAsset: 'assets/filters/princess_crown.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.3,
      heightRatio: 0.6,
      centerOffset: Offset(0, -0.35),
    ),
    // Sparkle overlay across face
    FilterLayer(
      imageAsset: 'assets/filters/princess_sparkles.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 1.8,
      heightRatio: 1.8,
    ),
  ],
);
