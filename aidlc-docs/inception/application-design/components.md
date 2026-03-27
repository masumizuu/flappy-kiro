# Components - Flappy Kiro

## Technology Stack
- **Language**: Swift
- **UI Framework**: SwiftUI (app shell, window management)
- **Game Framework**: SpriteKit (scene graph, rendering, physics)
- **Game Loop**: `CADisplayLink` (frame-synced, 60 FPS)
- **Audio**: `AVAudioEngine` with programmatic tone synthesis; fallback to `.wav` assets
- **Theme**: Catppuccin Mocha
- **Fonts**: Sora (headings), JetBrains Mono (body) — bundled from Google Fonts

---

## Component Overview

```
FlappyKiroApp (SwiftUI App Entry)
└── GameWindowView (SwiftUI View)
    └── SpriteView (hosts SKScene)
        └── GameScene (SKScene - orchestrator)
            ├── PhysicsComponent
            ├── WallSpawner
            ├── ScoreComponent
            ├── DifficultyComponent
            ├── CollisionHandler
            ├── RenderComponent
            ├── InputHandler
            └── AudioManager
```

---

## Component Definitions

### 1. FlappyKiroApp
- **Type**: SwiftUI `App`
- **Responsibility**: Application entry point. Configures the main window with a minimum size of 400×600pt and hosts `GameWindowView`.

### 2. GameWindowView
- **Type**: SwiftUI `View`
- **Responsibility**: Wraps the SpriteKit scene in a `SpriteView`. Passes the current window geometry to `GameScene` to support proportional letterbox scaling.

### 3. GameScene
- **Type**: `SKScene` subclass
- **Responsibility**: Central game orchestrator. Owns the game state machine (`idle → playing → gameOver`), drives the per-frame update loop, coordinates all sub-components, and manages scene transitions.

### 4. PhysicsComponent
- **Type**: Swift class, owned by `GameScene`
- **Responsibility**: Manages Ghosty's vertical motion — gravity acceleration, upward velocity impulse on jump, and boundary clamping.

### 5. WallSpawner
- **Type**: Swift class, owned by `GameScene`
- **Responsibility**: Spawns wall pairs at timed intervals with randomised gap heights. Scrolls walls left at the current speed. Removes off-screen walls.

### 6. ScoreComponent
- **Type**: Swift class, owned by `GameScene`
- **Responsibility**: Tracks current score. Detects gap passage and increments score. Notifies `DifficultyComponent` and the HUD on change.

### 7. DifficultyComponent
- **Type**: Swift class, owned by `GameScene`
- **Responsibility**: Computes scroll speed from the current score using a gradual speed curve. Provides the active speed value to `WallSpawner` and `PhysicsComponent`.

### 8. CollisionHandler
- **Type**: Swift class, implements `SKPhysicsContactDelegate`, owned by `GameScene`
- **Responsibility**: Detects Ghosty collisions with walls or the ground. Triggers the game-over state transition.

### 9. RenderComponent
- **Type**: Swift class / node factory, owned by `GameScene`
- **Responsibility**: Programmatically creates all visual nodes (`SKShapeNode`, `SKLabelNode`) using the Catppuccin Mocha palette. Responsible for Ghosty, walls, ground, background, HUD score label, Start screen, and Game Over screen. Handles font loading (Sora, JetBrains Mono).

### 10. InputHandler
- **Type**: Swift class, owned by `GameScene`
- **Responsibility**: Captures macOS keyboard events (Spacebar). Routes jump to `PhysicsComponent` during play; routes start/restart to `GameScene` on the appropriate screens.

### 11. AudioManager
- **Type**: Swift class (singleton), owned by `GameScene`
- **Responsibility**: Synthesises jump and game-over sounds via `AVAudioEngine` (sine-wave with ADSR envelope). Falls back to `AVAudioPlayer` with `assets/jump.wav` / `assets/game_over.wav` if synthesis fails.
