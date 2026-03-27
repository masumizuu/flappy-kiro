# Code Generation Plan - Flappy Kiro

## Unit Context
- **Unit**: Flappy Kiro macOS App (single unit)
- **Workspace Root**: `/Users/tsukki/aidlc-workshop`
- **Application Code Root**: `/Users/tsukki/aidlc-workshop/FlappyKiro/`
- **Documentation Root**: `aidlc-docs/construction/flappy-kiro/code/`
- **Platform**: macOS native (Swift + SwiftUI + SpriteKit)
- **Special Note**: User is new to Swift — every file must include thorough doc comments and inline explanations

---

## Generation Steps

### Step 1: Project Structure Setup
- [x] Create Xcode project scaffold directories
- [x] Copy `assets/jump.wav` and `assets/game_over.wav` into `FlappyKiro/Resources/Audio/`
- [x] Create `FlappyKiro/FlappyKiro.entitlements`
- [x] Create `FlappyKiro/Info.plist`
- [x] Create `README.md` at workspace root

### Step 2: Constants
- [x] Create `FlappyKiro/Constants/PhysicsConstants.swift`
- [x] Create `FlappyKiro/Constants/LayoutConstants.swift`
- [x] Create `FlappyKiro/Constants/DifficultyConstants.swift`
- [x] Create `FlappyKiro/Constants/ColorPalette.swift`

### Step 3: Logger Utility
- [x] Create `FlappyKiro/Game/Logger.swift`

### Step 4: Domain Types
- [x] Create `FlappyKiro/Game/GameState.swift`
- [x] Create `FlappyKiro/Game/WallPair.swift`

### Step 5: Physics Component
- [x] Create `FlappyKiro/Game/PhysicsComponent.swift`

### Step 6: Difficulty Component
- [x] Create `FlappyKiro/Game/DifficultyComponent.swift`

### Step 7: Score Component
- [x] Create `FlappyKiro/Game/ScoreComponent.swift`

### Step 8: Wall Spawner
- [x] Create `FlappyKiro/Game/WallSpawner.swift`

### Step 9: Collision Handler
- [x] Create `FlappyKiro/Game/CollisionHandler.swift`

### Step 10: Input Handler
- [x] Create `FlappyKiro/Game/InputHandler.swift`

### Step 11: Audio Manager
- [x] Create `FlappyKiro/Game/AudioManager.swift`

### Step 12: Render Component
- [x] Create `FlappyKiro/Rendering/RenderComponent.swift`

### Step 13: Game Scene
- [x] Create `FlappyKiro/Game/GameScene.swift`

### Step 14: App Shell
- [x] Create `FlappyKiro/App/GameWindowView.swift`
- [x] Create `FlappyKiro/App/FlappyKiroApp.swift`

### Step 15: Documentation Summary
- [x] Create `aidlc-docs/construction/flappy-kiro/code/code-summary.md`
