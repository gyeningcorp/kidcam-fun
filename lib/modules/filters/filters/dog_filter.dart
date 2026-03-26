import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const dogFilter = FilterDefinition(
  id: 'dog',
  displayName: 'Dog',
  emoji: '\u{1F436}',
  thumbnailAsset: 'assets/filters/dog_ears.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Floppy ears on top of head
    FilterLayer(
      imageAsset: 'assets/filters/dog_ears.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.6,
      heightRatio: 0.7,
      centerOffset: Offset(0, -0.25),
    ),
    // Black nose
    FilterLayer(
      imageAsset: 'assets/filters/dog_nose.png',
      anchor: FilterAnchor(landmarkType: 'nose'),
      widthRatio: 0.3,
      heightRatio: 1.0,
    ),
    // Tongue hanging out from mouth
    FilterLayer(
      imageAsset: 'assets/filters/dog_tongue.png',
      anchor: FilterAnchor(landmarkType: 'mouth'),
      widthRatio: 0.35,
      heightRatio: 1.2,
      centerOffset: Offset(0, 0.15),
    ),
  ],
);
