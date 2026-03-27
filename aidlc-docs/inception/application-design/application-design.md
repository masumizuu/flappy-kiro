# Application Design - Flappy Kiro

> Consolidated design document. See individual files for full detail.

---

## Technology Stack

| Concern | Technology |
|---|---|
| Language | Swift |
| App shell | SwiftUI |
| Game rendering | SpriteKit (`SKScene`, `SKShapeNode`, `SKLabelNode`) |
| Game loop | `CADisplayLink` (60 FPS, frame-synced) |
| Audio | `AVAudioEngine` (programmatic synthesis); fallback `AVAudioPlayer` + `.wav` |
| Theme | Catppuccin Mocha |
| Fonts | Sora (headings), JetBrains Mono (body) — bundled from Google Fonts |
| Minimum window | 400 × 600 pt |
| Scaling strategy | Proportional letterbox (fixed internal coordinates) |

---

## Component Summary

| Component | Type | Responsibility |
|---|---|---|
| `FlappyKiroApp` | SwiftUI App | Entry point, window configuration |
| `GameWindowView` | SwiftUI View | Hosts SpriteKit scene, passes window size |
| `GameScene` | SKScene subclass | Game orchestrator, state machine, per-frame loop |
| `PhysicsComponent` | Swift class | Ghosty gravity, jump impulse, boundary clamping |
| `WallSpawner` | Swift class | Spawn, scroll, and remove wall pairs |
| `ScoreComponent` | Swift class | Score tracking, gap passthrough detection |
| `DifficultyComponent` | Swift class | Speed curve computation from score |
| `CollisionHandler` | SKPhysicsContactDelegate | Collision detection → game over trigger |
| `RenderComponent` | Swift class / node factory | All programmatic drawing (Catppuccin Mocha) |
| `InputHandler` | Swift class | Spacebar capture, action routing by game state |
| `AudioManager` | Swift singleton | Sound synthesis / playback, `.wav` fallback |

---

## Game State Machine

```
[Idle]  --Spacebar-->  [Playing]  --Collision-->  [GameOver]
                           ^                           |
                           |_______Spacebar____________|
```

---

## Data Flow (per frame)

```
CADisplayLink
    └── GameScene.update(deltaTime)
            ├── DifficultyComponent  → speed
            ├── PhysicsComponent     → Ghosty position
            ├── WallSpawner          → wall positions (uses speed)
            ├── ScoreComponent       → score (reads wall positions)
            └── RenderComponent      → HUD label update

Spacebar
    └── InputHandler
            ├── [idle]     → GameScene.startGame()
            ├── [playing]  → PhysicsComponent.applyJump() + AudioManager.playJump()
            └── [gameOver] → GameScene.restartGame()

Collision (event-driven)
    └── CollisionHandler
            └── GameScene.triggerGameOver()
                    ├── AudioManager.playGameOver()
                    └── RenderComponent.makeGameOverScreen()
```

---

## Responsive Scaling

- Internal scene size: fixed (e.g., 400 × 600 pt logical units)
- On window resize: `GameWindowView` computes a uniform scale factor (`min(windowW/sceneW, windowH/sceneH)`) and applies it to the `SpriteView`, producing letterbox/pillarbox bars in the Catppuccin Mocha base colour.
- All game logic operates in fixed internal coordinates — no adaptation needed at the logic layer.

---

## Audio Strategy

1. `AudioManager.setup()` attempts to configure `AVAudioEngine` synthesis graph.
2. **Success** → programmatic sine-wave tones with ADSR envelopes for jump and game-over sounds.
3. **Failure** → `AVAudioPlayer` loads `assets/jump.wav` and `assets/game_over.wav` from the app bundle.
4. All errors logged to stderr via `print()` for debug; no user-visible audio errors.

---

## Security Notes (applicable at design stage)

| Rule | Status | Notes |
|---|---|---|
| SECURITY-09 (Error handling) | Compliant | Errors logged to stderr only; no internal details exposed to UI |
| SECURITY-15 (Exception handling) | Compliant | Audio fallback path handles synthesis failure gracefully; fail-safe defaults applied |
| SECURITY-01/02/06/07/08/12/14 | N/A | No data stores, no network, no auth, no cloud infra |

---

## Detailed Artifacts

- [`components.md`](./components.md) — Full component definitions and responsibilities
- [`component-methods.md`](./component-methods.md) — Method signatures and I/O types
- [`services.md`](./services.md) — Orchestration service design and state machine
- [`component-dependency.md`](./component-dependency.md) — Dependency matrix and data flow diagram
