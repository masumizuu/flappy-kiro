# Frontend Components - Flappy Kiro

> All UI is rendered inside a single `SKScene`. This document describes the visual layer
> structure, screen layouts, and node hierarchy for each game state.

---

## Catppuccin Mocha Palette Reference

| Name | Hex | Usage |
|---|---|---|
| `base` | #1E1E2E | Background, letterbox bars |
| `surface0` | #313244 | Wall borders, ground |
| `surface1` | #45475A | Ground fill |
| `green` | #A6E3A1 | Wall fill |
| `lavender` | #B4BEFE | Ghosty tint, accent |
| `text` | #CDD6F4 | Ghosty body, primary text |
| `subtext1` | #BAC2DE | Secondary text, prompts |
| `mauve` | #CBA6F7 | Score label, title accent |
| `red` | #F38BA8 | Game Over title |
| `peach` | #FAB387 | Ghosty hands |

---

## Screen 1: Start Screen (`idle` state)

### Node Hierarchy
```
startScreenNode (SKNode container)
├── backgroundNode       — full-scene gradient (base → crust)
├── groundNode           — ground bar at bottom
├── titleLabel           — "Flappy Kiro" (Sora, 42pt, mauve)
├── subtitleLabel        — "A Ghosty Adventure" (JetBrains Mono, 16pt, subtext1)
├── ghostyNode           — Ghosty centred, idle bob animation
└── promptLabel          — "Press SPACE to start" (JetBrains Mono, 14pt, subtext1, pulsing alpha)
```

### Layout (scene coords 400 × 600)
- Title: centred at (200, 420)
- Subtitle: centred at (200, 385)
- Ghosty: centred at (200, 280), gentle up/down bob (±8pt, 1.2s loop)
- Prompt: centred at (200, 160)

---

## Screen 2: Gameplay HUD (`playing` state)

### Node Hierarchy
```
gameplayLayer (SKNode)
├── backgroundNode       — static background
├── groundNode           — ground bar (physics body: static rect)
├── wallsLayer           — parent node for all WallPair nodes
│   └── [WallPair nodes] — top wall + bottom wall per pair
├── ghostyNode           — Ghosty (physics body: circle)
└── hudNode
    └── scoreLabel       — current score (Sora, 32pt, mauve, top-left)
```

### HUD Layout
- Score label: position (20, sceneHeight − 20), anchor top-left

### Ghosty Visual Spec
```
Body:    Rounded oval, 36 × 40 pt, fill: text (#CDD6F4), stroke: lavender (#B4BEFE) 2pt
Tail:    3 wavy bumps at bottom, each ~8pt wide, same fill as body
Hands:   Two small ovals (12 × 8 pt) extending left and right at mid-body, fill: peach (#FAB387)
Eyes:    Two filled circles, 5pt radius, fill: base (#1E1E2E), positioned upper-centre of body
Mouth:   "w" shape drawn with 3 short line segments, stroke: base (#1E1E2E), 1.5pt width
```

### Wall Visual Spec
```
Each wall segment: rounded rect, width 52pt, fill: green (#A6E3A1), stroke: surface0 (#313244) 2pt
Corner radius: 6pt
```

### Ground Visual Spec
```
Rectangle: full width × 60pt, fill: surface1 (#45475A), top stroke: surface0 (#313244) 2pt
```

---

## Screen 3: Game Over Screen (`gameOver` state)

### Node Hierarchy
```
gameOverScreenNode (SKNode container, overlaid on gameplay layer)
├── dimOverlay           — semi-transparent rect, fill: base (#1E1E2E) at 70% alpha
├── gameOverLabel        — "Game Over" (Sora, 40pt, red #F38BA8)
├── scoreLabel           — "Score: [N]" (Sora, 28pt, mauve)
└── restartPrompt        — "Press SPACE to restart" (JetBrains Mono, 14pt, subtext1, pulsing alpha)
```

### Layout
- Game Over label: centred at (200, 360)
- Score label: centred at (200, 300)
- Restart prompt: centred at (200, 220)

---

## Animations

| Animation | Target | Description |
|---|---|---|
| Idle bob | Ghosty (Start screen) | `SKAction` move up +8pt and back, 1.2s, repeat forever, ease in/out |
| Prompt pulse | "Press SPACE" labels | `SKAction` fade alpha 1.0 → 0.3 → 1.0, 1.0s, repeat forever |
| Ghosty tilt | Ghosty (playing) | Rotate node: tilt up (+15°) on jump, tilt down (−20°) on fall, interpolated each frame from velocity |

---

## Font Loading

Fonts are bundled in the app target (`.ttf` files added to Xcode project and listed in `Info.plist` under `UIAppFonts` / `ATSApplicationFontsPath`):
- `Sora-Regular.ttf`, `Sora-SemiBold.ttf`
- `JetBrainsMono-Regular.ttf`

Fallback: if a custom font fails to load, use system font (`NSFont.systemFont`) — log error to stderr.
