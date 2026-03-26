# KidCam Fun 📸🎉

**A toy, not an app. Safe by design.**

A kid-friendly face filter camera app for ages 4–10. Fully offline. No accounts. No cloud. No dark patterns. Just a child and a pile of silly filters.

## Quick Links
- 📋 [Full Blueprint](./BLUEPRINT.md) — PRD, architecture, UX flows, QA plan
- 📦 [pubspec.yaml](./pubspec.yaml) — Flutter dependencies

## Core Philosophy
- Safe by design, not safe later
- Parents trust it. Kids love it.
- No network = no risk
- Feels like a toy, not a social network

## MVP Features
- 10 face filters (cat, dog, dino, princess, superhero, pirate, space, monster, rainbow, snowflake)
- Live face tracking (Google ML Kit, on-device)
- Swipe to change filters
- Photo capture → local-only storage
- Parent gate (math challenge) for settings/export
- Zero network calls, zero accounts, zero dark patterns

## Tech Stack
- **Framework:** Flutter 3.x
- **Face Detection:** Google ML Kit (on-device)
- **State:** Riverpod 2
- **Storage:** App sandbox + optional photo library (parent toggle)
- **Audio:** Local assets only

## Build (estimated)
- MVP: 10 weeks
- Phase 2: +6 weeks

## Safety
See `BLUEPRINT.md` → Safety & Privacy Checklist (100% of boxes must be checked before ship)

---
*Built for Chris by Rory | March 2026*
