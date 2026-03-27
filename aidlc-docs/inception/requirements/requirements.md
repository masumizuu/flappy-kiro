# Flappy Kiro - Requirements Document

## Intent Analysis Summary

- **User Request**: Build a Flappy Bird clone called "Flappy Kiro" — an arcade game where the player controls a ghost (Ghosty) navigating through randomly-placed wall gaps.
- **Request Type**: New Project (Greenfield)
- **Scope Estimate**: Single Component (self-contained game application)
- **Complexity Estimate**: Moderate (game loop, physics, rendering, input handling, progressive difficulty)

---

## Functional Requirements

### FR-01: Platform
- The game MUST run as a native macOS desktop application.
- Technology stack: **Swift + SwiftUI** (standard for macOS native app development).

### FR-02: Game Character
- The player controls a ghost character named **Ghosty**.
- Ghosty moves persistently to the right at a constant horizontal speed (increasing over time per FR-08).
- Ghosty automatically descends due to gravity.
- Ghosty ascends only when the player presses the **Spacebar**.

### FR-03: Obstacles
- Walls appear as vertical obstacles with a gap placed at a **random height**.
- Gaps are **equally sized** across all wall pairs.
- Walls scroll from right to left as Ghosty moves forward.

### FR-04: Scoring
- The player earns **1 point** for each wall pair successfully passed.
- The current score is displayed during gameplay.

### FR-05: Collision Detection
- Colliding with a wall (top or bottom segment) ends the game.
- Colliding with the ground ends the game.

### FR-06: Game Over Screen
- On collision, display a **Game Over screen** showing:
  - Final score
  - A **Restart** option to begin a new game

### FR-07: Progressive Difficulty
- Game speed **gradually increases** as the score goes up.
- Both wall scroll speed and Ghosty's horizontal speed increase proportionally.

### FR-08: Start Screen
- Display a start/title screen before gameplay begins.
- Player initiates the game via Spacebar press.

---

## Visual & Audio Requirements

### VR-01: Rendering
- All game visuals MUST be **drawn programmatically** — no external sprite or audio assets used.
- Style: **cutesy / whimsical**.

### VR-02: Color Scheme
- Use the **Catppuccin** color palette throughout the game UI and game world.
  - Reference: [Catppuccin](https://catppuccin.com) — use the Mocha or Latte flavor (to be confirmed during design).

### VR-03: Typography
- **Headings** (score display, screen titles): [Sora](https://fonts.google.com/specimen/Sora) from Google Fonts.
- **Body text** (instructions, labels): [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) from Google Fonts.

### VR-04: Audio
- Audio SHOULD be generated programmatically where possible (cutesy/whimsical style to match visuals).
- If programmatic audio generation is not feasible, fall back to the provided asset files:
  - `assets/jump.wav` — play on Spacebar press (Ghosty ascends)
  - `assets/game_over.wav` — play on collision (game ends)

---

## Non-Functional Requirements

### NFR-01: Performance
- The game loop MUST run at a stable **60 FPS** on modern macOS hardware.
- No frame drops during normal gameplay.

### NFR-02: Usability
- Single-key input (Spacebar) — no complex controls.
- Game state transitions (start → play → game over → restart) must be immediate and responsive.

### NFR-05: Responsive Layout
- The game window MUST be resizable and the game canvas MUST scale proportionally to fill the available window size.
- All UI elements (score display, screens, text) MUST reposition and rescale relative to the current window dimensions.
- A minimum window size SHOULD be enforced to prevent unplayable layouts (e.g., 400×600pt).

### NFR-03: Maintainability
- Code organized into clear, separated concerns: game loop, physics, rendering, input handling.

### NFR-04: Error Handling (Security-aligned)
- Use `console.error()` (or Swift equivalent: `print()` to stderr / `NSLog()`) for debug-level error output during development.
- Error messages shown to the user MUST be generic — no internal details exposed.

---

## Security Extension Configuration

| Extension | Enabled | Decided At |
|---|---|---|
| Security Baseline | Yes | Requirements Analysis |

### Security Notes
- User confirmed: enforce all SECURITY rules as blocking constraints.
- Debug errors should use `console.error()` equivalent (Swift: `print()` to stderr or a debug logger) — to be disabled before production deployment.
- Security rules will be evaluated at each applicable stage. Rules not applicable to a local desktop game (e.g., SECURITY-01 encryption at rest, SECURITY-02 network intermediaries, SECURITY-06 IAM policies, SECURITY-07 network config, SECURITY-14 cloud alerting) will be marked N/A with rationale.

---

## Key Constraints

- macOS native only (no web, no mobile, no cross-platform framework).
- No external asset files — everything drawn in code.
- Fonts loaded from Google Fonts (or bundled equivalents for offline use — to be resolved in design).
- No backend, no network calls, no data persistence beyond in-session score tracking.
