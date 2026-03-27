# Flappy Kiro 👻

A cutesy macOS arcade game where you guide **Ghosty** through an endless series of walls. Built natively with Swift and SpriteKit.

![Flappy Kiro](img/example-ui.png)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9+ |
| App Shell | SwiftUI |
| Game Engine | SpriteKit |
| Game Loop | CADisplayLink (60 FPS) |
| Audio | AVAudioEngine (programmatic synthesis) + AVAudioPlayer fallback |
| Fonts | Sora · JetBrains Mono (bundled) |
| Theme | Catppuccin Mocha |
| Build Tool | Xcode 15+ |
| Dependencies | None — 100% Apple native frameworks |

---

## Prerequisites

- macOS 13 Ventura or later
- Xcode 15 or later ([download from Mac App Store](https://apps.apple.com/app/xcode/id497799835))
- No additional package installation required

---

## Running in Development

1. Open the project in Xcode:
   ```bash
   open FlappyKiro.xcodeproj
   ```
2. Select the **FlappyKiro** scheme and your Mac as the run destination.
3. Press **⌘R** (or click the ▶ Run button).

The game window opens immediately. Press **Space** to start playing.

> **Tip**: Debug output (audio/font fallback warnings) appears in the Xcode console.

---

## Building for Production / Distribution

### Ad-hoc / Direct Distribution
1. In Xcode, select **Product → Archive** (⌘ + Shift + B won't work — use the menu).
2. In the Organizer window, click **Distribute App**.
3. Choose **Copy App** to export a `.app` bundle you can share directly.

### Mac App Store
1. Ensure you have an Apple Developer account and a valid provisioning profile.
2. Select **Product → Archive**, then **Distribute App → App Store Connect**.
3. Follow the Xcode upload wizard.

### Command-line Build (CI)
```bash
xcodebuild \
  -project FlappyKiro.xcodeproj \
  -scheme FlappyKiro \
  -configuration Release \
  -derivedDataPath build/ \
  build
```

The compiled `.app` will be at `build/Build/Products/Release/FlappyKiro.app`.

---

## Controls

| Key | Action |
|---|---|
| `Space` | Start game / Make Ghosty jump / Restart after game over |

---

## Project Structure

```
FlappyKiro/
├── App/
│   ├── FlappyKiroApp.swift       # SwiftUI entry point, window configuration
│   └── GameWindowView.swift      # Hosts SpriteKit scene, handles letterbox scaling
├── Game/
│   ├── GameScene.swift           # Central orchestrator, CADisplayLink loop, state machine
│   ├── GameState.swift           # Enum: idle | playing | gameOver
│   ├── WallPair.swift            # Wall pair entity (top + bottom wall nodes)
│   ├── PhysicsComponent.swift    # Ghosty gravity, jump, boundary clamping
│   ├── WallSpawner.swift         # Spawns, scrolls, and pools wall pairs
│   ├── ScoreComponent.swift      # Score tracking and gap passthrough detection
│   ├── DifficultyComponent.swift # Speed curve: score → scroll speed
│   ├── CollisionHandler.swift    # SKPhysicsContactDelegate → game over trigger
│   ├── InputHandler.swift        # Spacebar-only input routing
│   ├── AudioManager.swift        # AVAudioEngine synthesis + .wav fallback
│   └── Logger.swift              # Stderr-only debug logger
├── Rendering/
│   └── RenderComponent.swift     # All programmatic drawing (Ghosty, walls, screens)
├── Constants/
│   ├── PhysicsConstants.swift    # Gravity, jump velocity, terminal velocity
│   ├── LayoutConstants.swift     # Scene size, wall dimensions, spawn intervals
│   ├── DifficultyConstants.swift # Base speed, increment, cap
│   └── ColorPalette.swift        # Catppuccin Mocha SKColor definitions
└── Resources/
    ├── Fonts/                    # Sora + JetBrains Mono .ttf files
    └── Audio/                    # jump.wav, game_over.wav (fallback assets)
```

---

## Gameplay

- Ghosty automatically falls due to gravity
- Press **Space** to make Ghosty jump upward
- Navigate through the gaps in the walls — each gap cleared = 1 point
- Walls get faster as your score increases
- Hitting a wall or the ground ends the game

---

## License

MIT
