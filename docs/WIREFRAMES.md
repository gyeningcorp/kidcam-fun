# KidCam Fun — Screen Wireframes

## 1. Splash Screen
- Full-screen bright gradient background (sky blue to soft purple)
- Center: KidCam Fun logo in chunky cartoon letters
- Animated stars and sparkles floating upward
- No interactive elements — auto-advances after 1.5 seconds
- Sets the playful, magical tone for the entire app

## 2. Home Screen
- Soft gradient background with animated floating emoji (stars, balloons, butterflies)
- **CENTER:** Giant round "PLAY" button (180dp diameter)
  - Bright yellow-orange with bouncy pulse animation
  - Camera icon inside with "PLAY" text in large rounded font
- **BOTTOM RIGHT:** Small lock icon (40dp) in muted color
  - Entry point to parent gate — deliberately subtle so kids don't notice
- No other UI elements — maximum simplicity for young children

## 3. Camera Screen (Main Play Experience)
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
│  [🐱] [🐶] [🦕] [👑] [🦸]   │  ← Filter preview strip
│         ↑ active filter         │
│                                 │
│         [ 📷 ]                  │  ← Giant capture button (80dp)
└─────────────────────────────────┘
```
- Swipe LEFT/RIGHT on camera view to change filter
- Filter thumbnails in horizontal scrollable strip below camera
- Active filter highlighted with white glow ring
- Capture button: white circle with bright border, satisfying tap animation
- Sound icon (top right): child can toggle sounds on/off
- Back arrow: returns to Home screen
- **Filter Transition:** Slides out left/right, 150ms spring curve, "boing" sound
- **Expression Reaction:** Smile detected triggers burst of stars/hearts for 2 seconds

## 4. Photo Taken Screen
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
- Auto-saves captured photo to app sandbox
- "Awesome!" text with confetti/star burst celebration animation
- "Keep Playing" button returns to camera instantly
- "Save" button only visible if parent has enabled photo library saving
- **NO share button. NO send button. EVER.**
- Positive reinforcement animation — fun but not addictive

## 5. Parent Gate Screen
```
┌─────────────────────────────────┐
│   🔒 Parent Area                │
│                                 │
│   "What is 3 + 4?"             │
│                                 │
│   [  7  ] ← number pad        │
│                                 │
│   [Cancel]                     │
└─────────────────────────────────┘
```
- Math challenge: 2 random single-digit numbers, addition only
- Randomized each time (prevents memorization)
- 3 wrong attempts triggers 60-second cooldown
- Large number buttons for fat-finger accuracy
- Friendly character (emoji) asks the question
- No biometrics (child could watch parent unlock)
- No text password (child could memorize)

## 6. Parent Settings Screen
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
- All settings persisted via flutter_secure_storage
- Save to Photos toggle requires system photo library permission when enabled
- Clear all photos shows confirmation dialog before deletion
- Premium section is placeholder for Phase 2 IAP
- About section shows version, links to privacy policy and terms

## 7. Privacy Explanation Screen
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
- Written in plain English, not legal jargon
- Big green checkmarks for each safety point
- Friendly, reassuring tone
- Accessible from parent settings (no gate required for reading)

## Design Principles
1. **Minimal text** — icons and color over words (many users can't read yet)
2. **Big touch targets** — minimum 48dp, ideally 64dp+ for primary actions
3. **No small print** — everything is large, clear, and friendly
4. **Bright but not overwhelming** — soft pastels with pops of color
5. **No dark patterns** — no timers, no streaks, no guilt mechanics
6. **Parent UI is separate** — settings look clearly different from play UI
