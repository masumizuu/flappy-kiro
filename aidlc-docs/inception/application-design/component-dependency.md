# Component Dependencies - Flappy Kiro

## Dependency Matrix

| Component | Depends On | Communication Pattern |
|---|---|---|
| `FlappyKiroApp` | `GameWindowView` | SwiftUI view composition |
| `GameWindowView` | `GameScene` | Hosts via `SpriteView`; passes window size |
| `GameScene` | `PhysicsComponent`, `WallSpawner`, `ScoreComponent`, `DifficultyComponent`, `CollisionHandler`, `RenderComponent`, `InputHandler`, `AudioManager` | Direct ownership; calls `update()` each frame |
| `PhysicsComponent` | `RenderComponent` (Ghosty node) | Reads/writes Ghosty node position |
| `WallSpawner` | `RenderComponent`, `DifficultyComponent` | Uses render factory to create wall nodes; reads speed from difficulty |
| `ScoreComponent` | `WallSpawner` | Reads wall positions to detect passthrough |
| `DifficultyComponent` | `ScoreComponent` | Reads current score to compute speed |
| `CollisionHandler` | `GameScene` | Calls `triggerGameOver()` on contact |
| `RenderComponent` | — | No dependencies; pure node factory |
| `InputHandler` | `GameScene`, `PhysicsComponent` | Calls `applyJump()` or `startGame()` / `restartGame()` |
| `AudioManager` | — | Standalone; uses `AVAudioEngine` / `AVAudioPlayer` |

---

## Data Flow Diagram

```
Spacebar
   |
   v
InputHandler
   |-- [playing]  --> PhysicsComponent.applyJump()
   |-- [idle]     --> GameScene.startGame()
   |-- [gameOver] --> GameScene.restartGame()

CADisplayLink tick
   |
   v
GameScene.update(deltaTime)
   |
   +-> DifficultyComponent.currentSpeed(score) --> speed: CGFloat
   |
   +-> PhysicsComponent.update(deltaTime)
   |       |
   |       +--> updates Ghosty SKNode position
   |
   +-> WallSpawner.update(deltaTime, speed)
   |       |
   |       +--> scrolls wall SKNodes
   |       +--> spawns new WallPair via RenderComponent
   |       +--> removes off-screen walls
   |
   +-> ScoreComponent.checkPassthrough(ghostyX, walls)
   |       |
   |       +--> increments score
   |       +--> updates HUD SKLabelNode via RenderComponent
   |
   +-> CollisionHandler (event-driven via SKPhysicsContactDelegate)
           |
           +--> GameScene.triggerGameOver()
                   |
                   +--> AudioManager.playGameOver()
                   +--> RenderComponent.makeGameOverScreen()
                   +--> stops update loop
```

---

## Key Design Decisions

- **No circular dependencies**: `RenderComponent` is a pure factory with no back-references.
- **`GameScene` as single coordinator**: Sub-components do not call each other directly (except `WallSpawner` → `DifficultyComponent` for speed, and `ScoreComponent` → wall data).
- **`AudioManager` as singleton**: Ensures the `AVAudioEngine` is set up once and shared; avoids multiple engine instances.
- **Letterbox scaling in `GameWindowView`**: Window resize events are handled at the SwiftUI layer and passed down, keeping `GameScene` logic in fixed internal coordinates.
