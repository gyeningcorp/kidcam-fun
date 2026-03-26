import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const catFilter = FilterDefinition(
  id: 'cat',
  displayName: 'Cat',
  emoji: '\u{1F431}',
  thumbnailAsset: 'assets/filters/cat_ears.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Ears on top of head
    FilterLayer(
      imageAsset: 'assets/filters/cat_ears.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.4,
      heightRatio: 0.6,
      centerOffset: Offset(0, -0.3),
    ),
    // Whiskers centered on nose
    FilterLayer(
      imageAsset: 'assets/filters/cat_whiskers.png',
      anchor: FilterAnchor(landmarkType: 'nose'),
      widthRatio: 1.6,
      heightRatio: 0.5,
      centerOffset: Offset(0, 0.05),
    ),
    // Pink nose on nose tip
    FilterLayer(
      imageAsset: 'assets/filters/cat_nose.png',
      anchor: FilterAnchor(landmarkType: 'nose'),
      widthRatio: 0.25,
      heightRatio: 1.0,
    ),
  ],
);
