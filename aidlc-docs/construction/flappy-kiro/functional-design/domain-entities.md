# Domain Entities - Flappy Kiro

## GameState (Enum)
Represents the current phase of the game.

```
GameState
├── idle        — Start screen shown, waiting for first Spacebar press
├── playing     — Active gameplay loop running
└── gameOver    — Collision occurred, Game Over screen shown
```

---

## Ghosty (Entity)

The player-controlled character.

| Property | Type | Description |
|---|---|---|
| `position` | `CGPoint` | Current centre position in scene coordinates |
| `velocity` | `CGFloat` | Current vertical velocity (positive = up, negative = down) |
| `size` | `CGSize` | Bounding box: width = 36pt, height = 40pt |
| `physicsBody` | `SKPhysicsBody` | Circle body for SpriteKit collision detection |

**Visual**: Cutesy ghost shape — rounded oval body tapering to a wavy tail, two small outstretched hands, face drawn as "OwO" (wide dot eyes, small "w" mouth). Drawn in Catppuccin Mocha `text` (#CDD6F4) with subtle `lavender` (#B4BEFE) tint.

---

## WallPair (Entity)

A pair of top and bottom wall segments with a gap between them.

| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier for passthrough tracking |
| `topWall` | `SKShapeNode` | Top wall node |
| `bottomWall` | `SKShapeNode` | Bottom wall node |
| `gapCentreY` | `CGFloat` | Y-coordinate of the gap centre in scene coordinates |
| `gapHeight` | `CGFloat` | Height of the gap (dynamic — see business rules) |
| `xPosition` | `CGFloat` | Current X position (shared by both wall nodes) |
| `passed` | `Bool` | Whether Ghosty has already passed this pair (prevents double-scoring) |

**Visual**: Rounded-rect walls in Catppuccin Mocha `green` (#A6E3A1) with `surface0` (#313244) border.

---

## GameScore (Value Object)

| Property | Type | Description |
|---|---|---|
| `current` | `Int` | Points earned this session (increments by 1 per wall pair passed) |

---

## PhysicsState (Value Object)

Encapsulates Ghosty's motion parameters.

| Property | Type | Description |
|---|---|---|
| `gravity` | `CGFloat` | Downward acceleration per second: `-1800 pt/s²` |
| `jumpVelocity` | `CGFloat` | Upward velocity applied on Spacebar: `+620 pt/s` |
| `terminalVelocity` | `CGFloat` | Maximum downward speed: `-900 pt/s` |

---

## DifficultyState (Value Object)

| Property | Type | Description |
|---|---|---|
| `baseSpeed` | `CGFloat` | Starting scroll speed: `220 pt/s` (fast enough to be engaging from score 0) |
| `speedIncrement` | `CGFloat` | Speed added per point scored: `8 pt/s` |
| `maxSpeed` | `CGFloat` | Speed cap: `520 pt/s` |

---

## AudioEvent (Enum)

```
AudioEvent
├── jump      — Triggered on Spacebar press during playing state
└── gameOver  — Triggered on collision
```

---

## SceneLayout (Value Object)

Fixed internal coordinate space used for all game logic.

| Property | Value | Description |
|---|---|---|
| `sceneWidth` | `400 pt` | Fixed internal width |
| `sceneHeight` | `600 pt` | Fixed internal height |
| `groundHeight` | `60 pt` | Height of the ground bar at the bottom |
| `ghostyStartX` | `100 pt` | Ghosty's fixed horizontal position |
| `ghostyStartY` | `300 pt` | Ghosty's starting vertical position |
| `wallWidth` | `52 pt` | Width of each wall segment |
| `wallSpawnX` | `460 pt` | X position where new walls spawn (just off right edge) |
| `wallSpawnInterval` | `1.6 s` | Time between wall pair spawns (decreases with speed) |
