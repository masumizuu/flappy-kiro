# Business Logic Model - Flappy Kiro

## 1. Game Loop (per frame)

Executed by `GameScene.update(deltaTime:)` only when `gameState == .playing`.

```
1. speed       ← DifficultyComponent.currentSpeed(score)
2. Ghosty      ← PhysicsComponent.update(deltaTime)
3. Walls       ← WallSpawner.update(deltaTime, speed)
4. Score       ← ScoreComponent.checkPassthrough(ghostyX, walls)
5. HUD         ← RenderComponent.updateScoreLabel(score)
```

---

## 2. Physics Model

### Gravity & Velocity
Applied every frame during `playing` state:

```
velocity = max(velocity + gravity × deltaTime, terminalVelocity)
position.y = position.y + velocity × deltaTime
```

Constants (from `PhysicsState`):
- `gravity` = −1800 pt/s²
- `jumpVelocity` = +620 pt/s
- `terminalVelocity` = −900 pt/s

### Jump
On Spacebar press:
```
velocity ← jumpVelocity   // overrides current velocity (not additive)
```

### Boundary Clamping
```
if position.y - ghostyHeight/2 <= groundHeight:
    triggerGameOver()
if position.y + ghostyHeight/2 >= sceneHeight:
    position.y = sceneHeight - ghostyHeight/2
    velocity = 0
```

---

## 3. Wall Spawning & Scrolling

### Scrolling
Each frame, all active wall nodes move left:
```
wall.xPosition -= speed × deltaTime
```

### Spawn Trigger
A new `WallPair` is spawned when the elapsed time since the last spawn exceeds the spawn interval:
```
spawnInterval = max(0.8, 1.6 - (score × 0.02))   // shrinks with score, floor at 0.8s
```

### Gap Generation (Dynamic)
Gap height is randomised per wall pair within a safe range:
```
minGap = ghostyHeight × 2.8    // always passable (~112 pt)
maxGap = ghostyHeight × 4.5    // generous upper bound (~180 pt)
gapHeight = random(minGap, maxGap)

// Gap centre Y is randomised within safe vertical bounds
minGapCentreY = groundHeight + gapHeight/2 + 20
maxGapCentreY = sceneHeight - gapHeight/2 - 20
gapCentreY = random(minGapCentreY, maxGapCentreY)
```

### Removal
```
if wall.xPosition + wallWidth < 0:
    remove wall from scene and active list
```

---

## 4. Score & Passthrough Detection

A wall pair is considered "passed" when Ghosty's X position moves past the wall's right edge and `passed == false`:
```
if ghostyX > wall.xPosition + wallWidth/2 AND wall.passed == false:
    score.current += 1
    wall.passed = true
```

---

## 5. Difficulty Curve

Linear speed increase starting from an engaging base speed:
```
currentSpeed = min(baseSpeed + score × speedIncrement, maxSpeed)
             = min(220 + score × 8, 520)
```

| Score | Speed (pt/s) |
|---|---|
| 0 | 220 |
| 5 | 260 |
| 10 | 300 |
| 20 | 380 |
| 37+ | 520 (capped) |

---

## 6. State Transitions

### idle → playing
- Trigger: Spacebar pressed on Start screen
- Actions: reset all components, remove Start screen overlay, start `CADisplayLink`

### playing → gameOver
- Trigger: `CollisionHandler.didBegin()` detects Ghosty ↔ wall or Ghosty ↔ ground contact
- Actions: stop `CADisplayLink`, play game-over audio, show Game Over screen overlay

### gameOver → playing
- Trigger: Spacebar pressed on Game Over screen
- Actions: same as idle → playing (full reset)

---

## 7. Audio Logic

```
on jump:
    AudioManager.playJump()
    // synthesised: short ascending sine tone ~200→400 Hz, 80ms, fast attack/decay
    // fallback: assets/jump.wav

on gameOver:
    AudioManager.playGameOver()
    // synthesised: descending tone ~300→100 Hz, 400ms, slow decay
    // fallback: assets/game_over.wav
```

---

## 8. Responsive Scaling

Computed once on window resize, applied to `SpriteView` transform:
```
scaleX = windowWidth  / sceneWidth   // 400
scaleY = windowHeight / sceneHeight  // 600
scale  = min(scaleX, scaleY)         // uniform, letterbox

// Letterbox bars filled with Catppuccin Mocha base (#1E1E2E)
```

All game logic operates exclusively in fixed scene coordinates (400 × 600 pt). Scale factor is never passed into game logic.
