import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const snowflakeFilter = FilterDefinition(
  id: 'snowflake',
  displayName: 'Snow',
  emoji: '\u{2744}\u{FE0F}',
  thumbnailAsset: 'assets/filters/snowflake_overlay.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'smile_stars',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Snowflake particles overlay
    FilterLayer(
      imageAsset: 'assets/filters/snowflake_overlay.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 2.5,
      heightRatio: 2.5,
    ),
    // Ice crown on top of head
    FilterLayer(
      imageAsset: 'assets/filters/snowflake_crown.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.3,
      heightRatio: 0.5,
      centerOffset: Offset(0, -0.3),
    ),
  ],
);
