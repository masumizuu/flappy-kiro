# NFR Design Patterns - Flappy Kiro

## Pattern 1: Game Loop — Fixed Timestep with CADisplayLink

**Addresses**: NFR-01 (Performance — 60 FPS)

**Design**:
- `CADisplayLink` fires a callback each display refresh (~16.7 ms at 60 Hz).
- `GameScene` computes `deltaTime = currentTime - lastUpdateTime` each tick.
- All physics and movement calculations use `deltaTime` — frame-rate independent.
- If a frame takes longer than expected (e.g., first frame), `deltaTime` is clamped to a maximum of `1/30s` to prevent physics tunnelling on slow frames.

```
CADisplayLink.tick()
    deltaTime = min(currentTime - lastTime, 1/30)
    lastTime  = currentTime
    GameScene.update(deltaTime)
```

---

## Pattern 2: Fallback Chain (Resilience)

**Addresses**: NFR-05 (Reliability), SECURITY-11 (Defence in depth), SECURITY-15 (Exception handling)

**Design**: Every external resource uses a two-level fallback chain. Failures are caught, logged, and the next level is attempted. The game never halts on a non-critical failure.

```
AudioManager.setup():
    try AVAudioEngine synthesis setup
    catch → log to stderr, set mode = .wavFallback
        try load AVAudioPlayer with .wav bundle assets
        catch → log to stderr, set mode = .silent

RenderComponent.loadFont(name:):
    if UIFont(name:size:) returns nil
        → log to stderr
        → use NSFont.systemFont(ofSize:)
```

---

## Pattern 3: Fail-Safe Input Filtering

**Addresses**: SECURITY-05 (Input validation), SECURITY-15 (Fail closed)

**Design**: `InputHandler` uses an explicit allowlist — only `kVK_Space` (keyCode 49) triggers any action. All other key codes are silently discarded. No user input is ever stored, logged, or forwarded.

```
func handleKeyDown(keyCode: UInt16, gameState: GameState) {
    guard keyCode == kVK_Space else { return }   // allowlist — all others dropped
    switch gameState { ... }
}
```

---

## Pattern 4: Structured Error Logging (stderr only)

**Addresses**: SECURITY-03 (Application logging), SECURITY-09 (No internal details to user)

**Design**: A lightweight `Logger` wrapper routes all debug output to stderr. User-facing UI never displays error details.

```swift
enum Logger {
    static func error(_ message: String, file: String = #file, line: Int = #line) {
        fputs("[ERROR] \(file):\(line) — \(message)\n", stderr)
    }
}
```

Rules enforced:
- No passwords, tokens, or PII ever passed to `Logger.error()` (none exist in this app).
- Production error responses (if any UI error state is ever added) show only generic messages.

---

## Pattern 5: Object Pool for Wall Nodes

**Addresses**: NFR-01 (Memory — no unbounded growth)

**Design**: `WallSpawner` maintains a small pool of reusable `WallPair` node containers. When a wall scrolls off-screen, its nodes are reset and returned to the pool rather than deallocated. This avoids repeated `SKNode` allocation/deallocation during gameplay.

```
pool: [WallPair]   // pre-allocated, size = 6 (max visible walls at any speed)

spawnWallPair():
    pair = pool.popFirst() ?? WallPair()   // reuse or create
    configure(pair, gapY, gapHeight)
    scene.addChild(pair)
    active.append(pair)

onWallOffScreen(pair):
    active.remove(pair)
    pair.removeFromParent()
    pool.append(pair)                      // return to pool
```

---

## Pattern 6: Proportional Letterbox Scaling

**Addresses**: NFR-04 (Responsive layout)

**Design**: `GameWindowView` observes the window's `GeometryReader` size. On change, it computes a uniform scale factor and applies it to the `SpriteView` frame. The `SKScene` itself always renders at its fixed 400 × 600 pt internal size.

```
scale = min(windowWidth / 400, windowHeight / 600)
spriteViewFrame = CGSize(width: 400 * scale, height: 600 * scale)
// Remaining window area filled with Catppuccin Mocha base (#1E1E2E) background
```

Game logic is completely isolated from window size — no coordinates need recalculation on resize.

---

## Pattern 7: Constants Centralisation

**Addresses**: NFR-03 (Maintainability — no magic numbers)

**Design**: All numeric and colour constants are defined in dedicated constant files. No inline literals appear in game logic.

| File | Contents |
|---|---|
| `PhysicsConstants.swift` | `gravity`, `jumpVelocity`, `terminalVelocity` |
| `LayoutConstants.swift` | `sceneWidth/Height`, `groundHeight`, `wallWidth`, `ghostySize`, spawn intervals |
| `DifficultyConstants.swift` | `baseSpeed`, `speedIncrement`, `maxSpeed` |
| `ColorPalette.swift` | All Catppuccin Mocha hex values as `NSColor` / `SKColor` constants |

---

## Security Compliance Summary

| Rule | Status | Pattern Applied |
|---|---|---|
| SECURITY-03 | Compliant | Pattern 4 — stderr-only structured logging |
| SECURITY-05 | Compliant | Pattern 3 — allowlist input filtering |
| SECURITY-09 | Compliant | Pattern 4 — no internal details in UI; no default credentials |
| SECURITY-10 | Compliant | Zero third-party dependencies; no lock file needed |
| SECURITY-11 | Compliant | Pattern 2 — defence in depth via fallback chain |
| SECURITY-15 | Compliant | Patterns 2 & 3 — all external calls wrapped in do/catch; fail-safe defaults |
