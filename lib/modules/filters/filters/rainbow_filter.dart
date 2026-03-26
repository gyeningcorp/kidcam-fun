import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const rainbowFilter = FilterDefinition(
  id: 'rainbow',
  displayName: 'Rainbow',
  emoji: '\u{1F308}',
  thumbnailAsset: 'assets/filters/rainbow_overlay.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Rainbow sparkle overlay across face
    FilterLayer(
      imageAsset: 'assets/filters/rainbow_overlay.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 2.0,
      heightRatio: 2.0,
    ),
    // Rainbow cheek blush
    FilterLayer(
      imageAsset: 'assets/filters/rainbow_cheeks.png',
      anchor: FilterAnchor(landmarkType: 'nose'),
      widthRatio: 1.4,
      heightRatio: 0.5,
      centerOffset: Offset(0, 0.1),
    ),
  ],
);
