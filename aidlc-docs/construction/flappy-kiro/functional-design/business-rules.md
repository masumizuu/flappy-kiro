# Business Rules - Flappy Kiro

## Physics Rules

| ID | Rule |
|---|---|
| PHY-01 | Ghosty's vertical velocity is set (not added) to `jumpVelocity` on each Spacebar press — no velocity stacking. |
| PHY-02 | Downward velocity is capped at `terminalVelocity` (−900 pt/s) to prevent uncontrollable free-fall. |
| PHY-03 | If Ghosty's top edge reaches the scene ceiling, velocity is zeroed and position is clamped — no passing through the top. |
| PHY-04 | If Ghosty's bottom edge reaches the ground plane (`y ≤ groundHeight`), game over is triggered immediately. |
| PHY-05 | Physics updates only execute when `gameState == .playing`. |

---

## Wall Rules

| ID | Rule |
|---|---|
| WAL-01 | Every wall gap MUST be passable: minimum gap height = `ghostyHeight × 2.8` (~112 pt). |
| WAL-02 | Gap height is randomised per wall pair between `minGap` and `maxGap` — no two consecutive pairs are guaranteed to have the same gap size. |
| WAL-03 | Gap centre Y is randomised within safe vertical bounds, ensuring the gap never clips the ground or ceiling. |
| WAL-04 | Wall pairs spawn off the right edge of the scene (`x = 460`) and are never visible at spawn time. |
| WAL-05 | Wall pairs are removed from the scene and memory once their right edge passes `x = 0`. |
| WAL-06 | Spawn interval decreases linearly with score (floor: 0.8 s) — walls appear more frequently at higher scores. |

---

## Scoring Rules

| ID | Rule |
|---|---|
| SCO-01 | Score increments by exactly 1 when Ghosty's X position passes the right edge of a wall pair's centre. |
| SCO-02 | Each wall pair can only award 1 point — the `passed` flag prevents double-counting. |
| SCO-03 | Score resets to 0 on every new game (no persistent high score). |
| SCO-04 | Score is displayed in the top-left corner of the scene at all times during `playing` state. |

---

## Difficulty Rules

| ID | Rule |
|---|---|
| DIF-01 | Base speed at score 0 is 220 pt/s — fast enough to be immediately engaging. |
| DIF-02 | Speed increases by 8 pt/s per point scored (linear). |
| DIF-03 | Speed is capped at 520 pt/s regardless of score. |
| DIF-04 | Speed is recalculated every frame from the current score — no stored speed state needed. |

---

## Input Rules

| ID | Rule |
|---|---|
| INP-01 | Only the Spacebar key triggers game actions — all other keys are ignored. |
| INP-02 | Spacebar on `idle` screen → start game. |
| INP-03 | Spacebar during `playing` → apply jump. |
| INP-04 | Spacebar on `gameOver` screen → restart game. |
| INP-05 | Input is ignored during state transitions (between state changes). |

---

## Game Over Rules

| ID | Rule |
|---|---|
| GOV-01 | Game over is triggered by any contact between Ghosty's physics body and a wall node or the ground node. |
| GOV-02 | On game over: the game loop stops immediately, game-over audio plays, and the Game Over screen is shown. |
| GOV-03 | The Game Over screen displays the final score for the current session only. |
| GOV-04 | No high score is tracked or displayed. |

---

## Audio Rules

| ID | Rule |
|---|---|
| AUD-01 | Jump sound plays on every Spacebar press during `playing` state. |
| AUD-02 | Game-over sound plays once when transitioning to `gameOver` state. |
| AUD-03 | If `AVAudioEngine` synthesis setup fails, `AVAudioPlayer` with `.wav` fallback is used silently — no error shown to user. |
| AUD-04 | Audio errors are logged to stderr only (`print()` to stderr). |

---

## Rendering Rules

| ID | Rule |
|---|---|
| REN-01 | All visuals are drawn programmatically using `SKShapeNode` and `SKLabelNode` — no external image assets used for game visuals. |
| REN-02 | All colours are sourced exclusively from the Catppuccin Mocha palette. |
| REN-03 | Headings (score, screen titles) use the Sora font. |
| REN-04 | Body text (instructions, prompts) uses JetBrains Mono font. |
| REN-05 | Ghosty is drawn as a cutesy ghost: rounded oval body tapering to a wavy tail, two small outstretched hands, "OwO" face (wide dot eyes, small "w" mouth). |
| REN-06 | Letterbox/pillarbox bars (when window aspect ratio differs from 400:600) are filled with Catppuccin Mocha `base` (#1E1E2E). |

---

## Security / Error Handling Rules

| ID | Rule |
|---|---|
| SEC-01 | All error conditions (audio failure, font loading failure) are handled gracefully with fallback behaviour — the game never crashes on non-critical failures. |
| SEC-02 | Error details are logged to stderr via `print()` for debug purposes only — never displayed to the user. |
| SEC-03 | No user input is persisted, transmitted, or stored beyond the current session. |
