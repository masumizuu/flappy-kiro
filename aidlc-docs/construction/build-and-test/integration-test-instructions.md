# Integration Test Instructions - Flappy Kiro

> Integration tests for a local macOS game are manual gameplay scenarios.
> There is no network, no database, and no inter-service communication to test.
> All integration testing is done by running the game and verifying behaviour.

---

## Setup

1. Build and run the game in Xcode (**⌘R**).
2. Ensure the Xcode console is visible (**View → Debug Area → Activate Console**).
3. Work through each scenario below in order.

---

## Scenario 1: Start Screen → Gameplay Transition

**Tests**: `InputHandler` → `GameScene.startGame()` → `PhysicsComponent` + `WallSpawner` activation

| Step | Action | Expected Result |
|---|---|---|
| 1 | Launch the game | Start screen appears; "Flappy Kiro" title in mauve; "Press SPACE to start" pulses |
| 2 | Observe Ghosty | Ghosty bobs up and down gently (idle animation) |
| 3 | Press Space | Start screen disappears; Ghosty begins falling; walls start scrolling from the right |
| 4 | Check console | No `[ERROR]` lines (only `[DEBUG]` for audio/font setup) |

---

## Scenario 2: Gameplay — Physics and Scoring

**Tests**: `PhysicsComponent` ↔ `WallSpawner` ↔ `ScoreComponent` ↔ `DifficultyComponent`

| Step | Action | Expected Result |
|---|---|---|
| 1 | During gameplay, do nothing | Ghosty falls steadily; hits ground → game over triggers |
| 2 | Start again; press Space repeatedly | Ghosty jumps upward each press; falls between presses |
| 3 | Navigate through a wall gap | Score increments by 1; HUD score label updates immediately |
| 4 | Play to score 10+ | Walls visibly scroll faster than at score 0 |
| 5 | Play to score 37+ | Speed plateaus — walls no longer accelerate |

---

## Scenario 3: Collision Detection → Game Over

**Tests**: `CollisionHandler` → `GameScene.triggerGameOver()` → `AudioManager` → `RenderComponent`

| Step | Action | Expected Result |
|---|---|---|
| 1 | Fly Ghosty into a wall | Game Over screen appears immediately |
| 2 | Let Ghosty fall to the ground | Game Over screen appears immediately |
| 3 | Check audio | Game-over sound plays (synthesised tone or `.wav`) |
| 4 | Verify screen content | "Game Over" in red; "Score: N" in mauve; "Press SPACE to restart" pulses |

---

## Scenario 4: Restart Flow

**Tests**: `GameScene.startGame()` full reset path

| Step | Action | Expected Result |
|---|---|---|
| 1 | On Game Over screen, press Space | Game Over screen disappears; gameplay resumes immediately |
| 2 | Verify score | Score resets to 0 in HUD |
| 3 | Verify walls | All previous walls removed; fresh walls spawn from right |
| 4 | Verify Ghosty | Ghosty back at starting position, no residual tilt |

---

## Scenario 5: Responsive Window Scaling

**Tests**: `GameWindowView` letterbox scaling

| Step | Action | Expected Result |
|---|---|---|
| 1 | Resize window wider than tall | Pillarbox bars appear on left/right in Catppuccin Mocha base colour |
| 2 | Resize window taller than wide | Letterbox bars appear top/bottom |
| 3 | Resize to minimum (400×600) | Game fills window exactly, no bars |
| 4 | Resize while playing | Game continues uninterrupted; no physics glitches |

---

## Scenario 6: Audio Fallback

**Tests**: `AudioManager` fallback chain

| Step | Action | Expected Result |
|---|---|---|
| 1 | Check Xcode console on launch | Either `[DEBUG] using AVAudioEngine synthesis` or `[DEBUG] using .wav fallback` |
| 2 | Press Space during gameplay | Jump sound plays |
| 3 | Trigger game over | Game-over sound plays |
| 4 | Rename `.wav` files temporarily, relaunch | Console shows `[ERROR]` for missing files; game runs silently — no crash |

---

## Pass Criteria

All 6 scenarios complete without crashes, freezes, or unexpected behaviour.
Console shows no unexpected `[ERROR]` lines during normal gameplay.
