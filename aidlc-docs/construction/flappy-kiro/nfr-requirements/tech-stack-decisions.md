# Tech Stack Decisions - Flappy Kiro

## Final Technology Stack

| Concern | Technology | Decision Rationale |
|---|---|---|
| Language | **Swift 5.9+** | Native macOS language; best-in-class Apple framework access |
| App shell | **SwiftUI** | Modern declarative macOS app structure; handles window lifecycle |
| Game rendering | **SpriteKit** | Apple's 2D game framework; built-in scene graph, physics, and `SKShapeNode` for programmatic drawing |
| Game loop | **`CADisplayLink`** | Frame-synced to display refresh; most accurate 60 FPS driver on macOS |
| Audio | **`AVAudioEngine`** (primary) + **`AVAudioPlayer`** (fallback) | Programmatic synthesis via `AVAudioEngine`; `.wav` fallback via `AVAudioPlayer` |
| Fonts | **Sora** + **JetBrains Mono** (bundled `.ttf`) | Google Fonts, bundled in app target for offline use |
| Dependency management | **Swift Package Manager (SPM)** | Native Apple toolchain; no third-party dependencies needed |
| Build system | **Xcode** | Required for macOS app development and code signing |
| Minimum macOS | **macOS 13 Ventura** | Broad hardware support (2017+ Intel, all Apple Silicon); SwiftUI + SpriteKit stable |

---

## Third-Party Dependencies

**None.** All required functionality is available in Apple's native frameworks:
- SpriteKit — rendering and physics
- AVFoundation — audio
- SwiftUI — app shell and window management
- CoreGraphics — geometry types

This satisfies SECURITY-10 (supply chain): no external package registries, no lock file complexity, no vulnerability surface from third-party packages.

---

## Project Structure

```
FlappyKiro/                          # Xcode project root
├── FlappyKiro.xcodeproj
├── FlappyKiro/
│   ├── App/
│   │   ├── FlappyKiroApp.swift      # SwiftUI App entry point
│   │   └── GameWindowView.swift     # SpriteView host, window size observer
│   ├── Game/
│   │   ├── GameScene.swift          # SKScene orchestrator, state machine
│   │   ├── PhysicsComponent.swift   # Ghosty physics
│   │   ├── WallSpawner.swift        # Wall spawning and scrolling
│   │   ├── ScoreComponent.swift     # Score tracking
│   │   ├── DifficultyComponent.swift# Speed curve
│   │   ├── CollisionHandler.swift   # SKPhysicsContactDelegate
│   │   ├── InputHandler.swift       # Keyboard input routing
│   │   └── AudioManager.swift       # AVAudioEngine + fallback
│   ├── Rendering/
│   │   └── RenderComponent.swift    # All programmatic drawing, fonts, colours
│   ├── Constants/
│   │   ├── PhysicsConstants.swift   # Gravity, jump velocity, terminal velocity
│   │   ├── LayoutConstants.swift    # Scene size, wall dimensions, spawn intervals
│   │   ├── DifficultyConstants.swift# Base speed, increment, cap
│   │   └── ColorPalette.swift       # Catppuccin Mocha colour definitions
│   ├── Resources/
│   │   ├── Fonts/
│   │   │   ├── Sora-Regular.ttf
│   │   │   ├── Sora-SemiBold.ttf
│   │   │   └── JetBrainsMono-Regular.ttf
│   │   └── Audio/
│   │       ├── jump.wav             # Fallback audio asset
│   │       └── game_over.wav        # Fallback audio asset
│   └── Info.plist
└── README.md
```

---

## Build Requirements

- Xcode 15+
- macOS 13 Ventura SDK
- No additional setup — pure native Swift, no package resolution needed
