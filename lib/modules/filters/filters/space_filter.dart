import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const spaceFilter = FilterDefinition(
  id: 'space',
  displayName: 'Space',
  emoji: '\u{1F680}',
  thumbnailAsset: 'assets/filters/space_helmet.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Space helmet covering full head
    FilterLayer(
      imageAsset: 'assets/filters/space_helmet.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 1.8,
      heightRatio: 2.0,
      centerOffset: Offset(0, -0.1),
    ),
    // Background stars overlay
    FilterLayer(
      imageAsset: 'assets/filters/space_stars.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 3.0,
      heightRatio: 3.0,
    ),
  ],
);
