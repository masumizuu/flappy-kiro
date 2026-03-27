# Unit Test Instructions - Flappy Kiro

> Flappy Kiro is a single-unit local macOS game with no backend or network layer.
> Unit tests focus on the pure logic components that have no UI or framework dependencies.

---

## Test Targets to Create in Xcode

Add a **FlappyKiroTests** target: **File → New → Target → Unit Testing Bundle**.

---

## Test Cases

### PhysicsComponentTests

**File**: `FlappyKiroTests/PhysicsComponentTests.swift`

| Test | What it verifies |
|---|---|
| `testJumpSetsVelocity` | `applyJump()` sets velocity to exactly `jumpVelocity` |
| `testGravityDecreasesVelocity` | After `update(deltaTime:)`, velocity is lower than before |
| `testTerminalVelocityClamped` | Velocity never drops below `terminalVelocity` regardless of deltaTime |
| `testResetRestoresStartPosition` | `reset()` puts Ghosty back at `ghostyStartX`, `ghostyStartY` with zero velocity |
| `testCeilingClamp` | Ghosty cannot move above `sceneHeight` |

### ScoreComponentTests

**File**: `FlappyKiroTests/ScoreComponentTests.swift`

| Test | What it verifies |
|---|---|
| `testInitialScoreIsZero` | Score starts at 0 |
| `testResetClearsScore` | `reset()` returns score to 0 |
| `testPassthroughIncrementsScore` | Score increments when ghostyX passes wall right edge |
| `testNoDubleCount` | Passing the same wall twice does not increment score twice |
| `testNoIncrementBeforeWall` | Score does not increment when ghostyX is left of wall |

### DifficultyComponentTests

**File**: `FlappyKiroTests/DifficultyComponentTests.swift`

| Test | What it verifies |
|---|---|
| `testBaseSpeedAtScoreZero` | Speed at score 0 equals `baseSpeed` (220) |
| `testLinearIncrease` | Speed at score 5 equals `baseSpeed + 5 × speedIncrement` |
| `testSpeedCappedAtMax` | Speed never exceeds `maxSpeed` (520) at any score |

### InputHandlerTests

**File**: `FlappyKiroTests/InputHandlerTests.swift`

| Test | What it verifies |
|---|---|
| `testSpacebarDuringIdleCallsOnStart` | Space + `.idle` → `onStart` fires |
| `testSpacebarDuringPlayingCallsOnJump` | Space + `.playing` → `onJump` fires |
| `testSpacebarDuringGameOverCallsOnStart` | Space + `.gameOver` → `onStart` fires |
| `testNonSpacebarIgnored` | Any other keyCode → neither callback fires |

---

## Running Tests

### In Xcode
Press **⌘U** or go to **Product → Test**.

### Command-line
```bash
xcodebuild test \
  -project FlappyKiro.xcodeproj \
  -scheme FlappyKiro \
  -destination 'platform=macOS'
```

---

## Expected Results

- All tests pass (green)
- No warnings about missing test cases
- Test navigator shows 100% pass rate for logic components

---

## Components Not Unit Tested (and why)

| Component | Reason |
|---|---|
| `RenderComponent` | Pure SKNode factory — requires a live SpriteKit context; covered by manual visual inspection |
| `AudioManager` | Hardware-dependent; synthesis path varies by machine; covered by manual audio check |
| `GameScene` | Integration-level orchestrator; covered by integration/manual testing |
| `CollisionHandler` | Requires live SKPhysicsWorld; covered by integration testing |
