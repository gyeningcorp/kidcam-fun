# KidCam Fun

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red)]()
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)]()
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20Offline-brightgreen)]()

**A toy, not an app. Safe by design.**

A kid-friendly face filter camera app for ages 4-10. Fully offline. No accounts. No cloud. No dark patterns. Just a child and a pile of silly filters.

<p align="center">
  <img src="docs/screenshots/home_screen.png" width="200" alt="Home Screen" />
  <img src="docs/screenshots/camera_cat.png" width="200" alt="Cat Filter" />
  <img src="docs/screenshots/camera_dino.png" width="200" alt="Dino Filter" />
  <img src="docs/screenshots/photo_taken.png" width="200" alt="Photo Taken" />
</p>

## Core Philosophy

- **Safe by design, not safe later** - every decision starts with "is this safe for a 4-year-old?"
- **Parents trust it. Kids love it.** - these two things must coexist
- **No network = no risk** - zero internet calls, zero data collection
- **Feels like a toy, not a social network** - no accounts, no sharing, no dark patterns

## MVP Features

| Feature | Status |
|---------|--------|
| 10 face filters (cat, dog, dino, princess, superhero, pirate, space, monster, rainbow, snowflake) | In Progress |
| Live face tracking (Google ML Kit, on-device) | In Progress |
| Swipe to change filters | In Progress |
| Photo capture with local-only storage | In Progress |
| Parent gate (math challenge) for settings/export | In Progress |
| Expression reactions (smile = stars!) | In Progress |
| Zero network calls, zero accounts | By Design |

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| Face Detection | Google ML Kit (on-device, no API key) |
| State Management | Riverpod 2.0 |
| Local Storage | App sandbox + sqflite |
| Audio | audioplayers (local assets only) |
| Animations | Rive + flutter_animate |

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Theme, routes, MaterialApp
├── core/
│   ├── constants/               # Colors, fonts, sounds
│   ├── models/                  # FaceData, FilterDefinition, CapturedMedia
│   └── utils/                   # Math challenge, device tier
├── modules/
│   ├── camera/                  # Camera controller, permissions
│   ├── face_tracking/           # ML Kit face detection, expression detection
│   ├── filters/                 # Filter engine, renderer, carousel, 10 filters
│   ├── storage/                 # Local storage, SQLite media index
│   ├── parent_gate/             # Math challenge gate, settings screen
│   └── safety/                  # Privacy screen
└── screens/                     # Splash, home, camera, photo taken
```

## Safety & Privacy

- Zero network calls from core app
- No API keys or endpoints in app binary
- Camera only active when Camera Screen is visible
- No user accounts, chat, or social features
- No share button anywhere in child-accessible UI
- Parent gate protects all settings and exports
- COPPA + GDPR-K compliant by design
- Apple Kids Category + Google Designed for Families ready

## Getting Started

```bash
# Clone the repo
git clone https://github.com/gyeningcorp/kidcam-fun.git
cd kidcam-fun

# Install dependencies
flutter pub get

# Run on device
flutter run
```

## Documentation

- [Full Blueprint](./BLUEPRINT.md) - PRD, architecture, UX flows, QA plan
- [Wireframes](./docs/WIREFRAMES.md) - Screen-by-screen wireframe descriptions

## Build Timeline

- **MVP:** 10 weeks (camera, filters, parent gate, storage)
- **Phase 2:** +6 weeks (video, stickers, play modes, premium filters)

---

*Built with care for kids and parents | 2026*
