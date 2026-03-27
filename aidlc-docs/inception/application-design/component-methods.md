# Component Methods - Flappy Kiro

> Note: Detailed business logic and rules are defined in Functional Design (Construction phase).
> This document covers method signatures, purposes, and input/output types.

---

## GameScene : SKScene

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `setupScene()` | Initialise all sub-components and add nodes to scene | — | `Void` |
| `startGame()` | Transition from idle to playing state | — | `Void` |
| `restartGame()` | Reset all state and restart from idle | — | `Void` |
| `triggerGameOver()` | Transition to game-over state, stop loop, play audio | — | `Void` |
| `update(_ currentTime: TimeInterval)` | Per-frame update; delegates to sub-components | `currentTime: TimeInterval` | `Void` |
| `updateWindowSize(_ size: CGSize)` | Recalculate scale factor for letterbox layout | `size: CGSize` | `Void` |

---

## PhysicsComponent

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `reset()` | Reset Ghosty position and velocity to initial state | — | `Void` |
| `applyJump()` | Apply upward velocity impulse to Ghosty | — | `Void` |
| `update(deltaTime: TimeInterval)` | Apply gravity, update position, clamp to bounds | `deltaTime: TimeInterval` | `Void` |
| `ghostyFrame() -> CGRect` | Return Ghosty's current bounding rect for collision | — | `CGRect` |

---

## WallSpawner

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `reset()` | Remove all walls, reset spawn timer | — | `Void` |
| `update(deltaTime: TimeInterval, speed: CGFloat)` | Scroll existing walls, spawn new ones on interval | `deltaTime`, `speed` | `Void` |
| `walls() -> [WallPair]` | Return current active wall pairs | — | `[WallPair]` |
| `spawnWallPair()` | Create a new wall pair with random gap position | — | `Void` |

---

## ScoreComponent

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `reset()` | Reset score to zero | — | `Void` |
| `checkPassthrough(ghostyX: CGFloat, walls: [WallPair])` | Detect if Ghosty has passed a wall gap; increment score | `ghostyX`, `walls` | `Void` |
| `currentScore() -> Int` | Return current score value | — | `Int` |

---

## DifficultyComponent

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `reset()` | Reset speed to initial value | — | `Void` |
| `currentSpeed(for score: Int) -> CGFloat` | Compute scroll speed from score using speed curve | `score: Int` | `CGFloat` |

---

## CollisionHandler : SKPhysicsContactDelegate

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `didBegin(_ contact: SKPhysicsContact)` | Handle physics contact; trigger game over on wall/ground hit | `contact: SKPhysicsContact` | `Void` |

---

## RenderComponent

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `makeBackground(size: CGSize) -> SKNode` | Create gradient background node (Catppuccin Mocha base) | `size: CGSize` | `SKNode` |
| `makeGround(size: CGSize) -> SKShapeNode` | Create ground bar node | `size: CGSize` | `SKShapeNode` |
| `makeGhosty() -> SKShapeNode` | Create Ghosty ghost shape node | — | `SKShapeNode` |
| `makeWallPair(gapY: CGFloat, gapHeight: CGFloat, sceneSize: CGSize) -> WallPair` | Create top + bottom wall nodes with gap | `gapY`, `gapHeight`, `sceneSize` | `WallPair` |
| `makeScoreLabel(score: Int) -> SKLabelNode` | Create/update HUD score label (Sora font) | `score: Int` | `SKLabelNode` |
| `makeStartScreen(size: CGSize) -> SKNode` | Create start screen overlay with title and prompt | `size: CGSize` | `SKNode` |
| `makeGameOverScreen(score: Int, size: CGSize) -> SKNode` | Create game-over overlay with score and restart prompt | `score: Int`, `size: CGSize` | `SKNode` |
| `applyLetterbox(sceneSize: CGSize, windowSize: CGSize) -> CGFloat` | Compute uniform scale factor for proportional fit | `sceneSize`, `windowSize` | `CGFloat` |

---

## InputHandler

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `handleKeyDown(keyCode: UInt16, gameState: GameState)` | Route Spacebar press to appropriate action per game state | `keyCode`, `gameState` | `Void` |

---

## AudioManager

| Method | Purpose | Inputs | Output |
|---|---|---|---|
| `setup()` | Configure `AVAudioEngine`; attempt to build synthesis graph | — | `Void` |
| `playJump()` | Play jump sound (synthesised or `.wav` fallback) | — | `Void` |
| `playGameOver()` | Play game-over sound (synthesised or `.wav` fallback) | — | `Void` |
| `teardown()` | Stop engine and release resources | — | `Void` |
