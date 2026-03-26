import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const monsterFilter = FilterDefinition(
  id: 'monster',
  displayName: 'Monster',
  emoji: '\u{1F47E}',
  thumbnailAsset: 'assets/filters/monster_horns.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'mouth_open_roar',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Monster horns on top of head
    FilterLayer(
      imageAsset: 'assets/filters/monster_horns.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.4,
      heightRatio: 0.7,
      centerOffset: Offset(0, -0.35),
    ),
    // Monster fangs at mouth
    FilterLayer(
      imageAsset: 'assets/filters/monster_teeth.png',
      anchor: FilterAnchor(landmarkType: 'mouth'),
      widthRatio: 0.6,
      heightRatio: 0.5,
      centerOffset: Offset(0, 0.05),
    ),
  ],
);
