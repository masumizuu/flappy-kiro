# Logical Components - Flappy Kiro

> This document maps NFR design patterns to the concrete Swift components that implement them.
> No external infrastructure components (queues, caches, databases) are required.

---

## Component: Logger (new — lightweight utility)

**Pattern**: Structured Error Logging (Pattern 4)  
**File**: `Game/Logger.swift`

```swift
/// Lightweight stderr logger for debug-only error output.
/// Never logs PII, credentials, or user-visible messages.
enum Logger {
    static func error(_ message: String, file: String = #file, line: Int = #line)
    static func debug(_ message: String, file: String = #file, line: Int = #line)
}
```

Used by: `AudioManager`, `RenderComponent` (font loading), `GameScene` (loop error boundary)

---

## Component: GameScene (updated — deltaTime clamping)

**Pattern**: Fixed Timestep Game Loop (Pattern 1)  
**File**: `Game/GameScene.swift`

Additional responsibility:
- Clamp `deltaTime` to `max(1/30s)` on each `CADisplayLink` tick before passing to sub-components.
- Maintain `lastUpdateTime: TimeInterval` as instance state.

---

## Component: WallSpawner (updated — object pool)

**Pattern**: Object Pool (Pattern 5)  
**File**: `Game/WallSpawner.swift`

Additional responsibility:
- Maintain `pool: [WallPair]` of pre-allocated node containers (initial size: 6).
- On spawn: dequeue from pool or allocate new.
- On removal: reset and re-enqueue to pool.

---

## Component: InputHandler (updated — allowlist)

**Pattern**: Fail-Safe Input Filtering (Pattern 3)  
**File**: `Game/InputHandler.swift`

Additional responsibility:
- Explicit `guard keyCode == kVK_Space else { return }` at the top of every key handler.
- No other key codes processed under any circumstances.

---

## Component: AudioManager (updated — fallback chain)

**Pattern**: Fallback Chain (Pattern 2)  
**File**: `Game/AudioManager.swift`

Audio mode state machine:
```
.synthesis   — AVAudioEngine programmatic tones (preferred)
.wavFallback — AVAudioPlayer with bundled .wav files
.silent      — both failed; no audio, no crash
```

Transitions:
- `setup()` attempts `.synthesis`; on failure → `.wavFallback`; on failure → `.silent`
- All transitions logged via `Logger.error()`

---

## Component: RenderComponent (updated — font fallback)

**Pattern**: Fallback Chain (Pattern 2)  
**File**: `Rendering/RenderComponent.swift`

Font loading:
```swift
func font(named name: String, size: CGFloat) -> NSFont {
    if let f = NSFont(name: name, size: size) { return f }
    Logger.error("Font '\(name)' not found, using system font")
    return NSFont.systemFont(ofSize: size)
}
```

---

## Component: GameWindowView (updated — letterbox scaling)

**Pattern**: Proportional Letterbox Scaling (Pattern 6)  
**File**: `App/GameWindowView.swift`

Additional responsibility:
- Use `GeometryReader` to observe window size changes.
- Compute `scale = min(w/400, h/600)` and size `SpriteView` accordingly.
- Wrap `SpriteView` in a `ZStack` with a `Color(hex: "#1E1E2E")` background to fill letterbox bars.

---

## Component: Constants Files (new)

**Pattern**: Constants Centralisation (Pattern 7)

| File | Key Constants |
|---|---|
| `Constants/PhysicsConstants.swift` | `gravity: CGFloat = -1800`, `jumpVelocity: CGFloat = 620`, `terminalVelocity: CGFloat = -900` |
| `Constants/LayoutConstants.swift` | `sceneSize: CGSize`, `groundHeight`, `wallWidth`, `ghostySize`, `wallSpawnInterval` |
| `Constants/DifficultyConstants.swift` | `baseSpeed: CGFloat = 220`, `speedIncrement: CGFloat = 8`, `maxSpeed: CGFloat = 520` |
| `Constants/ColorPalette.swift` | `SKColor` constants for all Catppuccin Mocha colours used in the game |

---

## No External Infrastructure Required

| Infrastructure Type | Status | Reason |
|---|---|---|
| Database / persistence | Not needed | Score is in-session only |
| Message queue | Not needed | Single-process, synchronous game loop |
| Cache | Not needed | Object pool handles node reuse in-memory |
| Network / API | Not needed | Fully offline local app |
| Cloud services | Not needed | macOS desktop app |
