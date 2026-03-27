# Code Summary - Flappy Kiro

## Generated Files

### App Shell
| File | Description |
|---|---|
| `FlappyKiro/App/FlappyKiroApp.swift` | SwiftUI `@main` entry point; configures window title and minimum size |
| `FlappyKiro/App/GameWindowView.swift` | Hosts SpriteKit scene in a `SpriteView`; handles letterbox scaling via `GeometryReader` |

### Game Logic
| File | Description |
|---|---|
| `FlappyKiro/Game/GameScene.swift` | Central orchestrator; `CADisplayLink` game loop; state machine (idle/playing/gameOver) |
| `FlappyKiro/Game/GameState.swift` | `GameState` enum with three cases |
| `FlappyKiro/Game/WallPair.swift` | Wall pair entity holding two `SKShapeNode` refs and metadata |
| `FlappyKiro/Game/PhysicsComponent.swift` | Ghosty gravity, jump impulse, boundary clamping |
| `FlappyKiro/Game/WallSpawner.swift` | Spawns/scrolls/recycles wall pairs; object pool of 6; dynamic gap randomisation |
| `FlappyKiro/Game/ScoreComponent.swift` | Score tracking; passthrough detection via X-position comparison |
| `FlappyKiro/Game/DifficultyComponent.swift` | Linear speed curve: `min(220 + score × 8, 520)` pt/s |
| `FlappyKiro/Game/CollisionHandler.swift` | `SKPhysicsContactDelegate`; physics category bitmasks; triggers game over |
| `FlappyKiro/Game/InputHandler.swift` | Spacebar-only allowlist; routes to jump/start/restart |
| `FlappyKiro/Game/AudioManager.swift` | `AVAudioEngine` sine-wave synthesis; fallback to `.wav` assets; silent mode |
| `FlappyKiro/Game/Logger.swift` | Stderr-only debug logger (`Logger.debug`, `Logger.error`) |

### Rendering
| File | Description |
|---|---|
| `FlappyKiro/Rendering/RenderComponent.swift` | All programmatic drawing: Ghosty (OwO ghost), walls, ground, HUD, start/game-over screens |

### Constants
| File | Description |
|---|---|
| `FlappyKiro/Constants/PhysicsConstants.swift` | Gravity, jump velocity, terminal velocity, max delta time |
| `FlappyKiro/Constants/LayoutConstants.swift` | Scene size, ground height, Ghosty size, wall dimensions, gap bounds |
| `FlappyKiro/Constants/DifficultyConstants.swift` | Base speed, speed increment, max speed |
| `FlappyKiro/Constants/ColorPalette.swift` | All Catppuccin Mocha colours as `SKColor` constants |

### Resources
| File | Description |
|---|---|
| `FlappyKiro/Resources/Audio/jump.wav` | Fallback jump sound |
| `FlappyKiro/Resources/Audio/game_over.wav` | Fallback game-over sound |
| `FlappyKiro/Resources/Fonts/` | Sora + JetBrains Mono `.ttf` files (add manually from Google Fonts) |
| `FlappyKiro/Info.plist` | App metadata; registers fonts via `ATSApplicationFontsPath` |
| `FlappyKiro/FlappyKiro.entitlements` | App Sandbox entitlements |

### Project Root
| File | Description |
|---|---|
| `README.md` | Full project README: overview, tech stack, dev/prod build instructions, controls, structure |

---

## Architecture Notes (for first-time Swift readers)

### Why CADisplayLink instead of SKScene.update()?
`CADisplayLink` fires in sync with the display refresh rate and gives us precise `deltaTime` control. We clamp `deltaTime` to `1/30s` to prevent physics objects from tunnelling through walls on slow frames.

### Why manual gravity instead of SpriteKit's built-in physics?
SpriteKit's `physicsWorld.gravity` is convenient but harder to tune for a game-feel-first approach. Manual gravity lets us set exact values (−1800 pt/s²) and apply jump as a velocity override rather than an impulse, giving consistent jump height regardless of current velocity.

### Why an object pool for walls?
`SKShapeNode` allocation and physics body setup are relatively expensive. At high scroll speeds, walls spawn every ~0.8s. Reusing 6 pre-allocated pairs eliminates GC pressure and keeps frame times stable.

### Why a fallback chain for audio?
`AVAudioEngine` synthesis can fail on some hardware configurations. Rather than crashing or going silent unexpectedly, we try synthesis first, then `.wav` files, then silent — always logging the reason to stderr.

---

## Build Instructions
See `README.md` at the project root for full build and run instructions.
