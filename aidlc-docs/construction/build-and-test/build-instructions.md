# Build Instructions - Flappy Kiro

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| macOS | 13 Ventura or later | Required for SwiftUI + SpriteKit APIs used |
| Xcode | 15 or later | [Download from Mac App Store](https://apps.apple.com/app/xcode/id497799835) |
| Swift | 5.9+ | Bundled with Xcode 15 |
| Dependencies | None | 100% Apple native frameworks — no package manager setup needed |

---

## Development Build (Run in Xcode)

### 1. Open the project
```bash
open /Users/tsukki/aidlc-workshop/FlappyKiro.xcodeproj
```
> If the `.xcodeproj` doesn't exist yet, create it in Xcode: **File → New → Project → macOS → App**, set the product name to `FlappyKiro`, language Swift, interface SwiftUI. Then add all files from `FlappyKiro/` to the target.

### 2. Add source files to the Xcode target
In Xcode's Project Navigator, ensure all `.swift` files under `FlappyKiro/` are added to the **FlappyKiro** target. Also add:
- `FlappyKiro/Resources/Fonts/*.ttf`
- `FlappyKiro/Resources/Audio/*.wav`
- `FlappyKiro/Info.plist`
- `FlappyKiro/FlappyKiro.entitlements`

### 3. Configure signing
In **Project → FlappyKiro target → Signing & Capabilities**:
- Enable **Automatically manage signing**
- Select your Apple ID team (or use "None" for local-only builds)

### 4. Run
Select the **FlappyKiro** scheme and your Mac as destination, then press **⌘R**.

**Expected output**: Game window opens at 400×600 pt. Press Space to start.

**Debug output**: Audio/font fallback warnings appear in the Xcode console (stderr).

---

## Production Build (Release Archive)

### Option A — Direct distribution (.app bundle)
1. In Xcode: **Product → Archive** (ensure scheme is set to **Release**)
2. In Organizer: **Distribute App → Copy App**
3. Export the `.app` — share directly or zip for distribution

### Option B — Mac App Store
1. Requires an Apple Developer Program membership
2. **Product → Archive → Distribute App → App Store Connect**
3. Follow the Xcode upload wizard

### Option C — Command-line (CI/CD)
```bash
xcodebuild \
  -project FlappyKiro.xcodeproj \
  -scheme FlappyKiro \
  -configuration Release \
  -derivedDataPath build/ \
  build
```
**Build artifact**: `build/Build/Products/Release/FlappyKiro.app`

---

## Verify Build Success

- No compiler errors or warnings about missing files
- App launches and displays the start screen
- Xcode console shows `[DEBUG]` lines (not `[ERROR]`) for audio and font setup
- Ghosty appears on screen with the OwO face and idle bob animation

---

## Troubleshooting

### "Font not found" in console
- Verify `.ttf` files are in `FlappyKiro/Resources/Fonts/`
- Verify `Info.plist` contains `ATSApplicationFontsPath = Resources/Fonts`
- Verify font files are added to the Xcode target's **Copy Bundle Resources** build phase
- Game falls back to system font automatically — this is non-blocking

### Audio synthesis warning in console
- `[ERROR] AudioManager: using .wav fallback` is expected on some hardware
- Verify `jump.wav` and `game_over.wav` are in `FlappyKiro/Resources/Audio/` and added to the target
- If both fail, game runs silently — this is non-blocking

### "No such module 'SpriteKit'" or 'AVFoundation'
- These are Apple system frameworks — ensure the target links them under **Build Phases → Link Binary With Libraries**
- Add: `SpriteKit.framework`, `AVFoundation.framework`, `Carbon.framework`
