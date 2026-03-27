# NFR Requirements - Flappy Kiro

## NFR-01: Performance

| Requirement | Target | Notes |
|---|---|---|
| Frame rate | Stable 60 FPS | `CADisplayLink` synced to display refresh rate |
| Frame budget | ≤ 16.7 ms per frame | All game logic + rendering must complete within one frame |
| Input latency | ≤ 1 frame (~17 ms) | Spacebar → jump response must feel immediate |
| Memory | No unbounded growth | Wall nodes removed from scene and deallocated when off-screen |
| CPU | Main thread only for game loop | No background threads needed; SpriteKit renders on its own thread |

**Verification**: Game must sustain 60 FPS on macOS hardware from 2019 onwards (Intel and Apple Silicon).

---

## NFR-02: Security

Security Baseline extension is **enabled**. Applicability per rule for a local macOS game:

| Rule | Applicable | Requirement |
|---|---|---|
| SECURITY-01 (Encryption at rest) | N/A | No data persistence |
| SECURITY-02 (Network access logging) | N/A | No network |
| SECURITY-03 (Application logging) | **Yes** | Errors logged to stderr via `print()` — no sensitive data in logs |
| SECURITY-04 (HTTP headers) | N/A | No web server |
| SECURITY-05 (Input validation) | **Yes** | Only Spacebar accepted; all other key input ignored |
| SECURITY-06 (Least-privilege IAM) | N/A | No cloud resources |
| SECURITY-07 (Network config) | N/A | No network |
| SECURITY-08 (App-level access control) | N/A | No auth, no user accounts |
| SECURITY-09 (Hardening) | **Yes** | No default credentials; error responses show no internal details |
| SECURITY-10 (Supply chain) | **Yes** | Swift Package Manager with pinned versions; lock file committed |
| SECURITY-11 (Secure design) | **Yes** | Audio/font failures handled with fallback; no single point of failure |
| SECURITY-12 (Auth & credentials) | N/A | No authentication |
| SECURITY-13 (Data integrity) | N/A | No external data ingestion |
| SECURITY-14 (Alerting) | N/A | No server infrastructure |
| SECURITY-15 (Exception handling) | **Yes** | All external calls (audio engine, font loading) wrapped in do/catch; fail-safe defaults applied |

**Applicable rules summary**: SECURITY-03, 05, 09, 10, 11, 15 — all must be compliant in generated code.

---

## NFR-03: Maintainability

| Requirement | Detail |
|---|---|
| Code documentation | Every Swift file MUST include a file-level comment explaining its purpose. Every public method MUST have a doc comment (`///`). |
| Inline comments | Non-obvious logic (physics constants, difficulty curve, gap randomisation) MUST have explanatory inline comments. |
| Separation of concerns | Each component in its own `.swift` file matching the application design. No logic mixed into SwiftUI views. |
| Constants | All magic numbers (physics values, colours, layout constants) defined as named constants — never inline literals. |
| README | A `README.md` at the project root explaining how to build, run, and understand the project (for a first-time Swift developer). |

---

## NFR-04: Usability & Accessibility

| Requirement | Detail |
|---|---|
| Responsive window | Game canvas scales proportionally (letterbox) on window resize; minimum window size enforced at 400 × 600 pt. |
| Font fallback | If Sora or JetBrains Mono fail to load, fall back to system font silently. |
| Single-key control | Only Spacebar required — no mouse, no modifier keys. |
| Readable score | Score label uses Sora 32pt in Catppuccin Mocha `mauve` — high contrast against dark background. |

---

## NFR-05: Reliability (Fault Tolerance)

| Failure Scenario | Handling |
|---|---|
| `AVAudioEngine` synthesis fails | Fall back to `AVAudioPlayer` + `.wav` assets; log error to stderr |
| `.wav` asset missing from bundle | Catch error, log to stderr, continue silently (no audio) |
| Custom font fails to load | Fall back to `NSFont.systemFont`; log error to stderr |
| `CADisplayLink` callback throws | Wrap update loop in do/catch; log error; attempt to continue |

All failures follow the **fail-safe** principle: the game continues running in a degraded-but-functional state.
