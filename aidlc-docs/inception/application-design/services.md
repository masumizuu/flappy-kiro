# Services - Flappy Kiro

> Flappy Kiro is a self-contained local game with no backend, network, or external services.
> "Services" in this context refers to the internal coordination layer — `GameScene` acting as the
> game service orchestrator, and `AudioManager` as a shared service.

---

## GameScene (Game Orchestration Service)

**Role**: Central coordinator. Owns the game state machine and drives all sub-components each frame.

### State Machine

```
[Idle / Start Screen]
        |
   Spacebar pressed
        |
        v
   [Playing]
        |
   Collision detected
        |
        v
  [Game Over Screen]
        |
   Spacebar pressed (restart)
        |
        v
   [Playing] (reset)
```

### Orchestration Responsibilities
- On each `update()` tick:
  1. Query `DifficultyComponent` for current speed
  2. Call `PhysicsComponent.update(deltaTime:)`
  3. Call `WallSpawner.update(deltaTime:speed:)`
  4. Call `ScoreComponent.checkPassthrough(ghostyX:walls:)`
  5. Update HUD score label via `RenderComponent`
- On game start / restart: call `reset()` on all sub-components, rebuild scene nodes
- On game over: stop update loop, call `AudioManager.playGameOver()`, show Game Over screen

---

## AudioManager (Shared Audio Service)

**Role**: Singleton audio service. Decouples sound playback from game logic.

### Service Contract
- `setup()` called once at app launch
- `playJump()` / `playGameOver()` called by `GameScene` at the appropriate moments
- `teardown()` called when the scene is deallocated

### Synthesis Strategy
1. Attempt to build `AVAudioEngine` synthesis graph on `setup()`
2. If synthesis setup succeeds → use programmatic tones
3. If synthesis setup fails → load `.wav` files from `assets/` bundle and use `AVAudioPlayer`
4. All errors logged via `print()` to stderr (debug mode); user never sees audio errors

---

## No External Services
The following are explicitly out of scope:
- No network requests
- No persistence / save files (score is in-session only)
- No analytics or telemetry
- No authentication
