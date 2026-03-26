import 'package:flutter/material.dart';

import '../../../core/constants/app_sounds.dart';
import '../../../core/models/filter_definition.dart';

const dinosaurFilter = FilterDefinition(
  id: 'dinosaur',
  displayName: 'Dino',
  emoji: '\u{1F995}',
  thumbnailAsset: 'assets/filters/dino_head.png',
  triggerSound: AppSounds.filterSwitch,
  expressionEffect: ExpressionEffect(
    type: 'mouth_open_roar',
    soundAsset: AppSounds.starsSparkle,
  ),
  layers: [
    // Dino spikes/crest on top of head
    FilterLayer(
      imageAsset: 'assets/filters/dino_head.png',
      anchor: FilterAnchor(landmarkType: 'topHead'),
      widthRatio: 1.5,
      heightRatio: 0.8,
      centerOffset: Offset(0, -0.35),
    ),
    // Scale texture overlay on face
    FilterLayer(
      imageAsset: 'assets/filters/dino_scales.png',
      anchor: FilterAnchor(landmarkType: 'face_center'),
      widthRatio: 1.2,
      heightRatio: 1.4,
    ),
  ],
);
