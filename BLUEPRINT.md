# KidCam Fun — Full Product Blueprint
*Version 1.0 | March 26, 2026*

---

## A. PRODUCT BLUEPRINT

### Vision
KidCam Fun is a **toy, not an app**. It's a magical camera playground for kids ages 4–10 that lives entirely on the device. No accounts, no cloud, no strangers. Just a child, a camera, and a pile of silly filters.

### Core Philosophy
- **Safe by design, not safe later.** Every decision starts with "is this safe for a 4-year-old?"
- **Parents trust it. Kids love it.** These two things must coexist.
- **Offline-first, always.** No network = no risk.
- **No dark patterns. Ever.** No timers, no streaks, no guilt mechanics.

---

### Product Requirements Document (PRD)

#### Problem Statement
Parents want creative, engaging apps for young children but face a minefield of social features, ads, data collection, and accidental sharing. No major filter app is truly designed for young children with safety as the foundational architecture — they bolt safety on after the fact.

#### Target Users
| User | Age | Need |
|------|-----|------|
| Primary: Child | 4–10 | Fun, playful, easy camera experience |
| Secondary: Parent | 25–45 | Safe, trustworthy, privacy-respecting app |

#### Key Differentiators
1. Truly local — zero network calls for core features
2. Parent gate is architecturally enforced, not optional
3. No engagement manipulation
4. COPPA + GDPR-K compliant by design
5. Apple Kids Category + Google Designed for Families program ready

---

## B. MVP SCOPE

### MVP (Ship First)
**Goal:** Working, beautiful, safe camera filter app in 8–10 weeks

| Feature | MVP | Phase 2 |
|---------|-----|---------|
| Live front camera | ✅ | |
| 10 face filters | ✅ | |
| Swipe to switch filters | ✅ | |
| Filter follows face | ✅ | |
| Photo capture | ✅ | |
| Local-only storage (app sandbox) | ✅ | |
| Parent gate (math challenge) | ✅ | |
| Sound on/off (parent setting) | ✅ | |
| Save to photo library (parent toggle) | ✅ | |
| Clear all photos (parent setting) | ✅ | |
| Camera permission error screen | ✅ | |
| Privacy screen in plain English | ✅ | |
| Smile-triggers-stars expression effect | ✅ | |
| Video capture (15s max) | | ✅ |
| Sticker/scene mode | | ✅ |
| Mini play modes (Roar, Magic Wand, etc.) | | ✅ |
| More filter packs (premium) | | ✅ |
| Voice-reactive effects | | ✅ |
| Multiple kid profiles | | ✅ |
| Printable templates | | ✅ |
| Session timer | | ✅ |

### MVP Filters (10)
1. 🐱 Cat ears + whiskers
2. 🐶 Dog ears + tongue
3. 🦕 Dinosaur face
4. 👑 Princess crown + sparkles
5. 🦸 Superhero mask
6. 🏴‍☠️ Pirate hat + eye patch
7. 🚀 Space helmet
8. 👾 Monster face
9. 🌈 Rainbow sparkle overlay
10. ❄️ Snowflake winter theme (seasonal swap: pumpkin/hearts)

---

## C. TECH STACK RECOMMENDATION

### Decision: Flutter (Recommended)

**Why Flutter over React Native:**
| Factor | Flutter | React Native |
|--------|---------|--------------|
| Camera/AR performance | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| On-device ML (TFLite) | Native integration | Bridge overhead |
| UI consistency | Pixel-perfect cross-platform | Platform-native (inconsistent) |
| Animation performance | 60/120fps Skia engine | JS bridge lag |
| Dart language | Simple, typed | JS/TS complexity |
| Kids app suitability | Excellent | Good |

**Stack:**

```
Language:         Dart (Flutter 3.x)
AR/Face Tracking: Google ML Kit Face Detection (on-device, free)
                  + flutter_mlkit_face_detection plugin
Camera:           camera plugin (official Flutter team)
                  OR camera_android_camerax for Android
Face Mesh (Phase 2): MediaPipe Face Mesh (on-device)
Local Storage:    path_provider + flutter_secure_storage (settings)
                  sqflite for media index/metadata
Image/Video:      image_gallery_saver (parent-triggered only)
                  video_player for playback
Audio (SFX):      audioplayers (local assets only, no CDN)
Animations:       Rive (pre-built playful animations, offline)
                  flutter_animate
Parent Gate:      Custom math/pattern challenge (no biometrics —
                  too complex for child to accidentally unlock)
State Management: Riverpod 2.0
IAP (Phase 2):    in_app_purchase (official Flutter plugin)
                  RevenueCat SDK (parent section only)
```

**On-Device Face Detection — Google ML Kit:**
- Free, no API key needed
- Runs fully on-device
- Detects: face bounds, landmarks (eyes, nose, mouth), smile probability, eye open probability
- Supports: iOS + Android
- Performance: ~30fps on mid-range devices (2022+)
- Fallback: If face not detected, filter stays in last known position for 1s then centers

**Performance Tiers:**
```
High-end (2022+ flagship):  Full face mesh, expression detection, 60fps
Mid-range (2020+ device):   Face landmarks, smile detection, 30fps  
Low-end (pre-2019):         Static filter at face bounding box only, 24fps
```

---

## D. UX FLOW

### Screen Architecture

```
App Launch
    │
    ▼
Splash Screen (1.5s, animated logo)
    │
    ▼
Home Screen
[🎮 Big PLAY button]
[🔒 Small parent lock icon — bottom corner]
    │
    ├──► PLAY ──► Camera Screen (main experience)
    │
    └──► 🔒 ──► Parent Gate ──► Parent Settings
```

### Screen-by-Screen Wireframe Descriptions

---

#### 1. Splash Screen
- Full-screen: bright gradient (sky blue → soft purple)
- Center: KidCam Fun logo — chunky cartoon letters
- Animated stars/sparkles floating up
- No text besides logo
- Auto-advances after 1.5s

---

#### 2. Home Screen
- Background: soft gradient, animated floating emoji (🌟 🎈 🦋)
- CENTER: Giant round "PLAY" button — 180dp diameter
  - Bright yellow-orange, bouncy pulse animation
  - Camera icon inside + "PLAY" text (large, rounded font)
- BOTTOM RIGHT: Small lock icon (🔒) 40dp — muted color, not prominent
  - This is the parent gate entry — subtle, not inviting to kids
- No other UI elements at this level

---

#### 3. Camera Screen (Main Play Experience)
```
┌─────────────────────────────────┐
│  [←]                    [🎵]   │  ← Back button + sound toggle
│                                 │
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │   LIVE CAMERA FEED      │   │
│  │   (face + filter        │   │
│  │    overlaid here)       │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  ◀ ● ● ● ● ● ● ● ● ● ● ▶    │  ← Filter carousel dots
│                                 │
│  [🐱] [🐶] [🦕] [👑] [🦸]   │  ← Filter preview strip (swipeable)
│         ↑ active filter         │
│                                 │
│         [ 📷 ]                  │  ← Giant capture button (80dp)
└─────────────────────────────────┘
```
- Swipe LEFT/RIGHT on camera view to change filter
- Filter thumbnails shown in horizontal strip below camera
- Active filter has white glow ring
- Capture button: white circle, bright border, satisfying tap animation
- Sound icon: 🎵 top right — child can tap to toggle sounds
- Back arrow: returns to Home

**Filter Transition Animation:**
- Filter slides out left/right as new one slides in (150ms, spring curve)
- Playful "boing" sound on change

**Expression Reaction (MVP):**
- Smile detected → burst of stars/hearts for 2 seconds
- No UI needed — just the overlay effect

---

#### 4. Photo Taken Screen
```
┌─────────────────────────────────┐
│                                 │
│   📸 [Photo preview — full     │
│        screen with filter]     │
│                                 │
│   "Awesome!" + star burst       │
│   animation                    │
│                                 │
│   [🔁 Keep Playing]  [💾 Save] │
│   (if parent enabled saving)   │
└─────────────────────────────────┘
```
- Auto-saves to app sandbox
- "Keep Playing" button → back to camera instantly
- "Save" button only visible if parent has enabled photo library saving
- No share button. No send button. None.
- Positive reinforcement animation (stars, confetti) — not addictive, just fun

---

#### 5. Parent Gate Screen
```
┌─────────────────────────────────┐
│   🔒 Parent Area                │
│                                 │
│   "What is 3 + 4?"             │  ← Simple math challenge
│                                 │
│   [  7  ] ← number pad        │
│                                 │
│   [Cancel]                     │
└─────────────────────────────────┘
```
- Math challenge: 2 random single-digit numbers, addition only
- Randomized each time (prevent kids memorizing answer)
- 3 wrong attempts = 60-second cooldown
- No biometrics (Face ID could be unlocked by parent while child watches)
- No text password (child could memorize)

---

#### 6. Parent Settings Screen
```
┌─────────────────────────────────┐
│  ← Parent Settings              │
│                                 │
│  🔊 Sound Effects    [ON │ OFF] │
│  📸 Save to Photos   [ON │ OFF] │
│  ⏱️ Session Timer    [OFF ▼ ]  │
│                                 │
│  ─────── Privacy ──────────    │
│  📖 How this app works         │
│  🗑️ Clear all saved photos     │
│                                 │
│  ─────── Premium ──────────    │
│  🔓 Unlock More Filters        │
│     $2.99 one-time purchase    │
│  ✅ Restore Purchase           │
│                                 │
│  ─────── About ─────────────   │
│  Version 1.0.0                 │
│  Privacy Policy                │
│  Terms of Use                  │
└─────────────────────────────────┘
```

---

#### 7. Privacy Explanation Screen (plain English)
```
How KidCam Fun Keeps Your Child Safe

✅ Everything stays on this phone
✅ No internet connection needed
✅ No account or login required
✅ We never see your child's photos
✅ No ads, no tracking
✅ Camera is only used inside the app
✅ Photos are only saved if YOU turn it on

KidCam Fun never sends any data anywhere.
It's just a toy — a really fun one.
```

---

## E. SAFETY & PRIVACY CHECKLIST

### Architecture Safety
- [ ] No network calls from core app (verified with network proxy test)
- [ ] No API keys or endpoints in app binary
- [ ] No third-party SDKs except: ML Kit (on-device), RevenueCat (parent-only, Phase 2)
- [ ] Camera permission requested with kid-friendly explanation
- [ ] Camera only active when Camera Screen is visible (lifecycle-managed)
- [ ] No background camera access
- [ ] Photo library write permission requested only after parent enables it
- [ ] App stores media in private app sandbox by default
- [ ] Media not accessible to other apps unless parent explicitly exports

### Child Safety
- [ ] No user accounts (no registration, no login)
- [ ] No chat, messaging, or communication of any kind
- [ ] No friend lists, social graph, or public content
- [ ] No share button anywhere in child-accessible UI
- [ ] Share sheet (iOS) never invoked from child UI
- [ ] No deep links that could take child to browser or other apps
- [ ] No external URLs accessible to child
- [ ] No in-app browser
- [ ] No ads visible to child
- [ ] No push notifications (or parent-gate notifications only)
- [ ] No location access requested

### Parent Gate Coverage
- [ ] Settings screen — gated
- [ ] Save to photo library toggle — gated
- [ ] Export/share from app — gated
- [ ] Clear all photos — gated
- [ ] In-app purchases — gated (+ standard IAP parental controls)
- [ ] Privacy policy / terms — accessible without gate (parent can always read)

### COPPA / Legal
- [ ] App does not collect personal information from children
- [ ] No behavioral advertising
- [ ] No persistent identifiers (no device ID collection, no IDFA)
- [ ] Privacy policy states clearly: no data collected from children
- [ ] Age rating: 4+ on iOS, Everyone on Android
- [ ] Apple Kids Category requirements met
- [ ] Google Designed for Families requirements met
- [ ] GDPR-K: no consent flows needed (no data collected)

### Data Minimization
- [ ] App analytics: NONE in MVP (or anonymous crash reporting parent-gated)
- [ ] No A/B testing SDK
- [ ] No user behavior tracking
- [ ] Crash reporting (if any): Sentry with IP anonymization, parent-gated opt-in

---

## F. BUILD ROADMAP

### Week-by-Week Plan (10-Week MVP)

```
Week 1 — Project Setup & Architecture
- Flutter project init (iOS + Android targets)
- Folder structure + module separation
- CI/CD setup (GitHub Actions → TestFlight + Firebase App Distribution)
- Base theme: colors, fonts, animation constants
- Camera permission flow

Week 2 — Camera Engine
- Flutter camera plugin integration
- Front/back camera toggle
- Camera preview widget (full-screen, no distortion)
- Permission denial error screen
- Performance baseline test on 3 device tiers

Week 3 — Face Detection Engine
- ML Kit Face Detection integration
- Real-time face bounding box + landmark extraction
- FaceData model (bounds, landmarks, smileProbability, leftEyeOpen, rightEyeOpen)
- 30fps detection loop with isolate offloading
- Fallback behavior for no face detected

Week 4 — Filter Engine (Part 1)
- Filter overlay rendering system (Canvas/CustomPainter)
- FilterDefinition model (assets, anchor points, scale rules)
- First 5 filters: cat, dog, dinosaur, princess crown, superhero mask
- Filter-to-face alignment algorithm
- Scale + rotation based on face bounds

Week 5 — Filter Engine (Part 2)
- Remaining 5 filters: pirate, space helmet, monster, rainbow, snowflake
- Filter carousel UI + swipe gesture
- Filter transition animations
- Smile detection → star burst effect
- Sound effects (local .mp3 assets)

Week 6 — Photo Capture + Local Storage
- Photo capture (composited camera + filter overlay)
- Save to app sandbox (Documents/KidCamPhotos/)
- Photo taken screen with positive animation
- Parent-gated save to photo library
- Media metadata index (SQLite)

Week 7 — Parent Gate + Settings
- Math challenge parent gate component
- Parent settings screen
- All settings toggle implementations
- Clear all photos with confirmation
- Session timer (optional — show gentle "time for a break" screen)

Week 8 — UI Polish + Kid UX
- Home screen with bouncy Play button
- Splash screen
- All animations pass
- Sound toggle in camera view
- Haptic feedback on capture
- Low reading requirement audit (replace text with icons where possible)
- Test with an actual kid (seriously — do this)

Week 9 — Privacy + Compliance
- Privacy explanation screen
- COPPA audit checklist complete
- Network proxy test (verify zero outbound calls)
- Apple Kids Category metadata
- Google Designed for Families metadata
- Privacy policy (hosted, linked from parent settings)

Week 10 — QA, Polish, Submit
- Full QA test plan execution
- Child safety & accidental sharing tests
- Performance test on low-end device
- TestFlight beta (send to 5–10 parents with kids)
- App Store submission
- Google Play submission
```

---

## G. EXAMPLE STARTER CODE ARCHITECTURE

### Folder Structure

```
kidcam_fun/
├── lib/
│   ├── main.dart
│   ├── app.dart                      # App root, theme, routes
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_fonts.dart
│   │   │   └── app_sounds.dart
│   │   ├── models/
│   │   │   ├── face_data.dart        # Face tracking data model
│   │   │   ├── filter_definition.dart
│   │   │   └── captured_media.dart
│   │   └── utils/
│   │       ├── math_challenge.dart   # Parent gate logic
│   │       └── device_tier.dart     # Performance tier detection
│   │
│   ├── modules/
│   │   │
│   │   ├── camera/                   # Camera Engine
│   │   │   ├── camera_controller_wrapper.dart
│   │   │   ├── camera_preview_widget.dart
│   │   │   └── camera_permission_handler.dart
│   │   │
│   │   ├── face_tracking/           # Face Tracking Engine
│   │   │   ├── face_detector_service.dart
│   │   │   ├── face_tracking_notifier.dart
│   │   │   └── expression_detector.dart
│   │   │
│   │   ├── filters/                  # Filter Engine
│   │   │   ├── filter_registry.dart  # All filters registered here
│   │   │   ├── filter_renderer.dart  # CustomPainter overlay
│   │   │   ├── filter_carousel.dart  # Swipeable filter selector
│   │   │   └── filters/
│   │   │       ├── cat_filter.dart
│   │   │       ├── dog_filter.dart
│   │   │       ├── dinosaur_filter.dart
│   │   │       ├── princess_filter.dart
│   │   │       ├── superhero_filter.dart
│   │   │       ├── pirate_filter.dart
│   │   │       ├── space_filter.dart
│   │   │       ├── monster_filter.dart
│   │   │       ├── rainbow_filter.dart
│   │   │       └── snowflake_filter.dart
│   │   │
│   │   ├── storage/                  # Local Storage Manager
│   │   │   ├── local_storage_service.dart
│   │   │   ├── media_index_db.dart   # SQLite index
│   │   │   └── photo_library_exporter.dart
│   │   │
│   │   ├── parent_gate/              # Parent Gate Module
│   │   │   ├── parent_gate_screen.dart
│   │   │   ├── parent_gate_service.dart
│   │   │   └── parent_settings_screen.dart
│   │   │
│   │   └── safety/                   # Safety/Privacy Controls
│   │       ├── privacy_screen.dart
│   │       ├── network_guard.dart    # Dev: asserts no network calls
│   │       └── share_prevention.dart # Blocks share sheet from child UI
│   │
│   └── screens/
│       ├── splash_screen.dart
│       ├── home_screen.dart
│       ├── camera_screen.dart
│       └── photo_taken_screen.dart
│
├── assets/
│   ├── filters/                      # Filter overlay images (PNG, transparent)
│   │   ├── cat_ears.png
│   │   ├── dog_ears.png
│   │   └── ...
│   ├── sounds/                       # Local SFX (no CDN)
│   │   ├── filter_switch.mp3
│   │   ├── photo_taken.mp3
│   │   ├── stars_sparkle.mp3
│   │   └── roar.mp3
│   ├── animations/                   # Rive animations
│   │   ├── sparkle_burst.riv
│   │   └── confetti.riv
│   └── fonts/
│       └── Nunito-Bold.ttf           # Rounded, friendly font
│
├── test/
│   ├── unit/
│   │   ├── face_data_test.dart
│   │   ├── parent_gate_test.dart
│   │   └── filter_registry_test.dart
│   ├── widget/
│   │   ├── home_screen_test.dart
│   │   └── parent_gate_screen_test.dart
│   └── safety/
│       └── no_network_calls_test.dart ← CRITICAL
│
├── ios/
├── android/
├── pubspec.yaml
└── README.md
```

---

### Key Code Scaffolding

#### `core/models/face_data.dart`
```dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceData {
  final Rect boundingBox;
  final Map<FaceLandmarkType, FaceLandmark?> landmarks;
  final double smileProbability;
  final double leftEyeOpenProbability;
  final double rightEyeOpenProbability;
  final double headEulerAngleY; // Left/right head tilt
  final double headEulerAngleX; // Up/down head tilt

  const FaceData({
    required this.boundingBox,
    required this.landmarks,
    required this.smileProbability,
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.headEulerAngleY,
    required this.headEulerAngleX,
  });

  factory FaceData.fromMLKitFace(Face face) {
    return FaceData(
      boundingBox: face.boundingBox,
      landmarks: face.landmarks,
      smileProbability: face.smilingProbability ?? 0.0,
      leftEyeOpenProbability: face.leftEyeOpenProbability ?? 1.0,
      rightEyeOpenProbability: face.rightEyeOpenProbability ?? 1.0,
      headEulerAngleY: face.headEulerAngleY ?? 0.0,
      headEulerAngleX: face.headEulerAngleX ?? 0.0,
    );
  }

  bool get isSmiling => smileProbability > 0.7;
  bool get isLookingLeft => headEulerAngleY > 20;
  bool get isLookingRight => headEulerAngleY < -20;
}
```

---

#### `core/models/filter_definition.dart`
```dart
import 'package:flutter/material.dart';

enum FilterCategory { free, premium }

class FilterAnchor {
  final String landmarkType; // 'nose', 'leftEye', 'rightEye', 'mouth', 'topHead'
  final Offset offset;       // Relative offset from anchor point
  const FilterAnchor({required this.landmarkType, required this.offset});
}

class FilterDefinition {
  final String id;
  final String displayName;
  final String emoji;
  final String thumbnailAsset;
  final List<FilterLayer> layers;
  final FilterCategory category;
  final String? triggerSound;   // Sound played on filter select
  final ExpressionEffect? expressionEffect; // Optional smile/etc reaction

  const FilterDefinition({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.thumbnailAsset,
    required this.layers,
    this.category = FilterCategory.free,
    this.triggerSound,
    this.expressionEffect,
  });
}

class FilterLayer {
  final String imageAsset;      // Path in assets/filters/
  final FilterAnchor anchor;
  final double widthRatio;      // Width as ratio of face bounding box width
  final double heightRatio;
  final Offset centerOffset;    // Fine-tune placement

  const FilterLayer({
    required this.imageAsset,
    required this.anchor,
    required this.widthRatio,
    this.heightRatio = 1.0,
    this.centerOffset = Offset.zero,
  });
}

class ExpressionEffect {
  final String type; // 'smile_stars', 'wink_sparkle', etc.
  final String soundAsset;
  const ExpressionEffect({required this.type, required this.soundAsset});
}
```

---

#### `modules/face_tracking/face_detector_service.dart`
```dart
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kidcam_fun/core/models/face_data.dart';

class FaceDetectorService {
  late final FaceDetector _detector;
  bool _isProcessing = false;

  FaceDetectorService() {
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true, // smile, eye open probability
        enableTracking: true,       // face ID tracking across frames
        minFaceSize: 0.15,          // ignore tiny faces in background
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  final StreamController<FaceData?> _faceDataController =
      StreamController<FaceData?>.broadcast();

  Stream<FaceData?> get faceStream => _faceDataController.stream;

  Future<void> processFrame(CameraImage image, InputImageRotation rotation) async {
    if (_isProcessing) return; // Drop frames if still processing
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image, rotation);
      final faces = await _detector.processImage(inputImage);

      if (faces.isEmpty) {
        _faceDataController.add(null);
      } else {
        // Use the largest face (closest to camera — the child)
        final primaryFace = faces.reduce(
          (a, b) => a.boundingBox.width > b.boundingBox.width ? a : b,
        );
        _faceDataController.add(FaceData.fromMLKitFace(primaryFace));
      }
    } catch (e) {
      // Silently drop failed frames — don't crash the camera
    } finally {
      _isProcessing = false;
    }
  }

  InputImage _buildInputImage(CameraImage image, InputImageRotation rotation) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: allBytes.done().buffer.asUint8List(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  void dispose() {
    _detector.close();
    _faceDataController.close();
  }
}
```

---

#### `modules/filters/filter_renderer.dart`
```dart
import 'package:flutter/material.dart';
import 'package:kidcam_fun/core/models/face_data.dart';
import 'package:kidcam_fun/core/models/filter_definition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FilterRenderer extends StatelessWidget {
  final FaceData? faceData;
  final FilterDefinition filter;
  final Size previewSize; // Camera preview widget size

  const FilterRenderer({
    super.key,
    required this.faceData,
    required this.filter,
    required this.previewSize,
  });

  @override
  Widget build(BuildContext context) {
    if (faceData == null) return const SizedBox.shrink();

    return CustomPaint(
      size: previewSize,
      painter: _FilterPainter(
        faceData: faceData!,
        filter: filter,
        previewSize: previewSize,
      ),
    );
  }
}

class _FilterPainter extends CustomPainter {
  final FaceData faceData;
  final FilterDefinition filter;
  final Size previewSize;

  _FilterPainter({
    required this.faceData,
    required this.filter,
    required this.previewSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in filter.layers) {
      _drawLayer(canvas, size, layer);
    }
  }

  void _drawLayer(Canvas canvas, Size size, FilterLayer layer) {
    final anchor = _resolveAnchorPoint(layer.anchor);
    if (anchor == null) return;

    final faceWidth = faceData.boundingBox.width;
    final overlayWidth = faceWidth * layer.widthRatio;
    final overlayHeight = overlayWidth * layer.heightRatio;

    // Center the overlay on the anchor + fine-tune offset
    final left = anchor.dx - overlayWidth / 2 + layer.centerOffset.dx * faceWidth;
    final top = anchor.dy - overlayHeight / 2 + layer.centerOffset.dy * faceWidth;

    final destRect = Rect.fromLTWH(left, top, overlayWidth, overlayHeight);

    // Note: In production, preload images as ui.Image in initState
    // This is simplified scaffolding
    canvas.drawRect(destRect, Paint()..color = Colors.transparent);
  }

  Offset? _resolveAnchorPoint(FilterAnchor anchor) {
    final face = faceData;
    switch (anchor.landmarkType) {
      case 'topHead':
        return Offset(
          face.boundingBox.center.dx,
          face.boundingBox.top,
        );
      case 'nose':
        return face.landmarks[FaceLandmarkType.noseBase]?.position.let(
          (p) => Offset(p.x.toDouble(), p.y.toDouble()),
        );
      case 'leftEye':
        return face.landmarks[FaceLandmarkType.leftEye]?.position.let(
          (p) => Offset(p.x.toDouble(), p.y.toDouble()),
        );
      case 'mouth':
        return face.landmarks[FaceLandmarkType.bottomMouth]?.position.let(
          (p) => Offset(p.x.toDouble(), p.y.toDouble()),
        );
      default:
        return face.boundingBox.center;
    }
  }

  @override
  bool shouldRepaint(_FilterPainter oldDelegate) =>
      oldDelegate.faceData != faceData || oldDelegate.filter != filter;
}
```

---

#### `modules/parent_gate/parent_gate_service.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';

class MathChallenge {
  final int a;
  final int b;
  final int answer;

  MathChallenge.generate()
      : a = Random().nextInt(9) + 1,
        b = Random().nextInt(9) + 1,
        answer = 0 {
    // Computed in factory below
  }

  factory MathChallenge.fresh() {
    final a = Random().nextInt(9) + 1;
    final b = Random().nextInt(9) + 1;
    return MathChallenge._internal(a, b, a + b);
  }

  MathChallenge._internal(this.a, this.b, this.answer);

  String get question => '$a + $b = ?';

  bool verify(String input) {
    final entered = int.tryParse(input);
    return entered == answer;
  }
}

class ParentGateService extends ChangeNotifier {
  int _failedAttempts = 0;
  DateTime? _cooldownUntil;
  bool _isUnlocked = false;

  bool get isOnCooldown =>
      _cooldownUntil != null && DateTime.now().isBefore(_cooldownUntil!);

  Duration get cooldownRemaining =>
      isOnCooldown ? _cooldownUntil!.difference(DateTime.now()) : Duration.zero;

  bool get isUnlocked => _isUnlocked;

  bool attemptUnlock(String answer, MathChallenge challenge) {
    if (isOnCooldown) return false;

    if (challenge.verify(answer)) {
      _failedAttempts = 0;
      _isUnlocked = true;
      notifyListeners();
      return true;
    }

    _failedAttempts++;
    if (_failedAttempts >= 3) {
      _cooldownUntil = DateTime.now().add(const Duration(seconds: 60));
      _failedAttempts = 0;
    }
    notifyListeners();
    return false;
  }

  void lock() {
    _isUnlocked = false;
    notifyListeners();
  }
}
```

---

#### `modules/storage/local_storage_service.dart`
```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalStorageService {
  static const _photoDir = 'KidCamPhotos';

  /// Get the app-private directory for photos
  Future<Directory> _getPhotoDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${appDir.path}/$_photoDir');
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }
    return photoDir;
  }

  /// Save photo to app sandbox (always, no permission needed)
  Future<File> saveToAppSandbox(List<int> imageBytes, String filename) async {
    final dir = await _getPhotoDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file;
  }

  /// Save to device photo library — REQUIRES parent permission toggle ON
  /// AND system photo library permission
  Future<bool> saveToPhotoLibrary(
    List<int> imageBytes, {
    required bool parentHasEnabledSaving,
  }) async {
    // Double-check parent has enabled this
    if (!parentHasEnabledSaving) {
      return false; // Silent fail — child should never hit this
    }

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(imageBytes),
      name: 'KidCamFun_${DateTime.now().millisecondsSinceEpoch}',
    );
    return result['isSuccess'] == true;
  }

  /// List all saved photos
  Future<List<File>> listPhotos() async {
    final dir = await _getPhotoDirectory();
    final files = await dir.list().toList();
    return files.whereType<File>().toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  }

  /// Clear ALL photos — parent gate required before calling
  Future<void> clearAllPhotos() async {
    final dir = await _getPhotoDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}

final localStorageProvider = Provider<LocalStorageService>(
  (_) => LocalStorageService(),
);
```

---

## DATABASE / STORAGE PLAN

### What's Stored
| Data | Location | Format | When Cleared |
|------|----------|--------|--------------|
| Captured photos | `Documents/KidCamPhotos/` | PNG | Parent clears or app uninstall |
| App settings | `flutter_secure_storage` | Key-value | App uninstall |
| Media index | `SQLite (sqflite)` | DB file | Parent clears |
| Parent gate state | In-memory only | - | App restart |

### What's NEVER Stored
- Camera frames (processed in memory, discarded immediately)
- Face tracking data (in memory, never persisted)
- Capture timestamps with metadata (no EXIF location)
- Any analytics or behavioral data

### SQLite Schema (media index)
```sql
CREATE TABLE media (
  id TEXT PRIMARY KEY,
  filename TEXT NOT NULL,
  filter_id TEXT NOT NULL,
  captured_at INTEGER NOT NULL,
  file_size INTEGER
  -- NO GPS, NO device info, NO face data
);
```

---

## MONETIZATION RECOMMENDATION

### Safest Model: Parent-Controlled One-Time Premium Unlock

**Model:**
- App is free with 10 filters (great experience on its own)
- One-time purchase: **"More Filters Pack"** — $2.99
  - Unlocks 15+ additional filter themes
  - No subscription, no recurring charge
  - Purchase lives in parent section only
  - No child-visible "unlock" prompts or upsells

**Why this model:**
- COPPA compliant: no purchases visible/accessible to child
- GDPR-K compliant: no purchase data tied to child
- Apple and Google require parental consent for purchases in Kids Category apps — this is already gated
- No manipulative mechanics
- Clear value exchange: parent decides once, child enjoys forever
- **Revenue estimate:** If 10,000 downloads, 15% conversion = 1,500 × $2.99 = ~$4,500 (minus 30% store cut = ~$3,150)

**What NOT to do:**
- ❌ No filter packs shown to child with "Buy Now" overlays
- ❌ No "unlock by watching an ad" (ads not allowed in Kids Category)
- ❌ No subscription
- ❌ No "premium filter" badge visible during play (creates desire loops)
- ❌ No in-app currency

---

## APP STORE SUBMISSION NOTES

### iOS — App Store (Kids Category)
- Declare: App is designed for children, ages 4–8
- Kids Category requirements:
  - No advertising networks
  - No analytics SDKs without Apple approval
  - No third-party logins
  - Parental consent for any data collection (we collect none — easy)
  - No links to external websites from child UI
  - Parent gate required for purchases ✅ (already implemented)
- IDFA: Request NO tracking (App Tracking Transparency — set to "Not Tracking")
- Privacy Nutrition Label: Camera (required, on-device only), Photo Library (optional, write-only)
- Age Rating: 4+

### Android — Google Play (Designed for Families)
- Target audience: Children
- Declare in content rating questionnaire: children's app
- No advertising unless compliant with Families Policy
- No persistent identifiers
- Data safety section: No data collected or shared
- Age rating: Everyone
- Content rating: ESRB Everyone / PEGI 3

---

## QA TEST PLAN

### Child Safety Tests (P0 — Must Pass Before Ship)
| Test | Expected Result |
|------|----------------|
| Tap every button in child UI — can share content? | NO share option anywhere |
| Is there any button that opens a URL in browser? | No external URLs |
| Can child access parent settings without gate? | No — math gate required |
| Can child initiate a purchase? | No — gated + IAP parental controls |
| Is network called at any point during normal use? | No (verify with Charles Proxy) |
| Does app request location permission? | Never |
| Does app function fully in airplane mode? | Yes — 100% offline |
| What happens if camera permission is denied? | Friendly error screen, no crash |
| Does share sheet appear anywhere in child flow? | Never |

### Performance Tests
| Test | Pass Threshold |
|------|---------------|
| Filter render latency (high-end device) | < 16ms (60fps) |
| Filter render latency (mid-range device) | < 33ms (30fps) |
| App launch to camera ready | < 2 seconds |
| Photo capture to preview | < 500ms |
| Memory usage during camera | < 200MB |
| Battery drain per 30 min session | < 8% |

### Parent Gate Tests
| Test | Expected |
|------|----------|
| Correct math answer unlocks | Yes |
| Wrong answer 3× triggers cooldown | 60s cooldown |
| Cooldown countdown visible | Yes |
| Gate re-locks when leaving parent area | Yes |
| Gate uses new challenge each time | Yes (random) |

### Privacy Audit
| Test | Expected |
|------|----------|
| Charles Proxy: no HTTP calls during use | 0 requests |
| App works in airplane mode | Yes |
| No GPS permission requested | Confirmed |
| Photo saved to sandbox has no EXIF GPS | Confirmed (strip EXIF on save) |
| Uninstall removes all data | Yes (app sandbox deleted) |

---

## CHILD-FRIENDLY UX GUIDELINES

1. **Minimum tap target: 64dp** — small fingers miss small buttons
2. **Font size minimum: 20sp** — early readers need large text
3. **Avoid text where icons work** — dinosaur emoji beats "Dinosaur Filter"
4. **Positive-only feedback** — no X marks, no "wrong", no failure states
5. **Immediate feedback** — every tap should respond within 100ms (visual + haptic)
6. **No loading screens** — everything loads ahead of time
7. **No error jargon** — "Oops! Can I use your camera?" not "Camera permission required"
8. **Bright colors, high contrast** — accessibility for young eyes
9. **No countdown timers** — creates anxiety in young children
10. **Session end is gentle** — if timer enabled: "Great playing! Time for a break!" with friendly animation, not alarm

---

*KidCam Fun Blueprint v1.0 — Built by Rory for Chris*
*Project folder: C:\Users\Yours Truly\OneDrive\Documents\Chris\Projects\kidcam-fun*
