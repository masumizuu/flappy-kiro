# Application Design Plan - Flappy Kiro

## Plan Checkboxes

- [x] Answer clarifying questions (Step 1)
- [x] Generate components.md
- [x] Generate component-methods.md
- [x] Generate services.md
- [x] Generate component-dependency.md
- [x] Generate application-design.md (consolidated)

---

## Clarifying Questions

Please fill in the `[Answer]:` tags below, then let me know when done.

---

### Question 1: Game Loop Driver
How should the game loop be driven in SwiftUI/macOS?

A) `CADisplayLink` — frame-synced timer tied to display refresh (most accurate for 60 FPS games)
B) `Timer` — simple periodic timer (easier but less precise)
C) Other (please describe after [Answer]: tag below)

[Answer]: 
A) CADisplayLink (This is my first time with Swift so I will need a detailed documentation about this project afterwards, okay? Thank you.)
---

### Question 2: Rendering Approach
How should the game world be rendered?

A) `SpriteKit` — Apple's 2D game framework (built-in physics, scene graph, audio; integrates with SwiftUI)
B) `Canvas` (SwiftUI) — draw everything manually each frame using SwiftUI's Canvas view
C) `Metal` / `MetalKit` — low-level GPU rendering (overkill for this game)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
A) SpriteKit - Apple's 2D game framework
---

### Question 3: Audio Generation
For the jump and game-over sounds, if programmatic audio is attempted:

A) Use `AVAudioEngine` with programmatic tone synthesis (sine wave / envelope shaping)
B) Skip programmatic audio entirely — use the provided `.wav` files directly via `AVAudioPlayer`
C) Try programmatic first; fall back to `.wav` files if synthesis sounds bad
D) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Use 'AVAudioEngine' with programmatic tone synthesis (I don't know what this is)
---

### Question 4: Window Responsiveness Strategy
For the responsive/resizable window requirement:

A) Scale the entire game canvas proportionally (letterbox/pillarbox if aspect ratio differs) — game logic uses fixed internal coordinates
B) Stretch the canvas to always fill the window (no letterboxing) — game logic adapts to actual window size
C) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Scale the entire game canvas proportionally
---

### Question 5: Catppuccin Flavor
Which Catppuccin flavor should be used as the primary theme?

A) Mocha (dark background — deep purples and blues)
B) Latte (light background — soft pastels on cream)
C) Frappé (medium-dark — muted cool tones)
D) Macchiato (medium — warm dark tones)
E) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Mocha (dark background - deep purples and blues)