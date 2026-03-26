import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const superheroFilter = FilterDefinition(
  id: 'superhero',
  displayName: 'Hero',
  emoji: '\u{1F9B8}',
  thumbnailAsset: 'assets/filters/superhero_mask.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Domino mask across eyes
    FilterLayer(
      imageAsset: 'assets/filters/superhero_mask.png',
      anchor: FilterAnchor(landmarkType: 'nose', offset: Offset(0, -0.1)),
      widthRatio: 1.1,
      heightRatio: 0.4,
    ),
    // Cape hint at shoulders
    FilterLayer(
      imageAsset: 'assets/filters/superhero_cape_hint.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 2.0,
      heightRatio: 1.0,
      centerOffset: Offset(0, 0.8),
    ),
  ],
);
