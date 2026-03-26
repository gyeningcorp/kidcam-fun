import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const pirateFilter = FilterDefinition(
  id: 'pirate',
  displayName: 'Pirate',
  emoji: '\u{1F3F4}\u{200D}\u{2620}\u{FE0F}',
  thumbnailAsset: 'assets/filters/pirate_hat.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'wink_sparkle',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Pirate hat on top of head
    FilterLayer(
      imageAsset: 'assets/filters/pirate_hat.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.6,
      heightRatio: 0.8,
      centerOffset: Offset(0, -0.4),
    ),
    // Eye patch on right eye
    FilterLayer(
      imageAsset: 'assets/filters/pirate_eyepatch.png',
      anchor: FilterAnchor(landmarkType: 'rightEye'),
      widthRatio: 0.4,
      heightRatio: 1.0,
    ),
  ],
);
