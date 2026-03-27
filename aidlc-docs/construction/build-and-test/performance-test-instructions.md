# Performance Test Instructions - Flappy Kiro

## Performance Requirements (from NFR-01)

| Metric | Target |
|---|---|
| Frame rate | Stable 60 FPS |
| Frame budget | ≤ 16.7 ms per frame |
| Input latency | ≤ 1 frame (~17 ms) |
| Memory | No unbounded growth over a long session |

---

## Test 1: Frame Rate Stability

**Tool**: Xcode Instruments → **Core Animation** profiler

### Steps
1. In Xcode, go to **Product → Profile** (⌘I) → select **Core Animation**
2. Run the game and start playing
3. Play for at least 2 minutes, reaching score 20+ (high scroll speed)
4. Observe the FPS graph

**Pass criteria**: FPS stays at 60 (or display refresh rate) with no sustained drops below 55.

---

## Test 2: Memory — No Unbounded Growth

**Tool**: Xcode Instruments → **Leaks** or **Allocations**

### Steps
1. **Product → Profile** → select **Allocations**
2. Start the game and play continuously for 5 minutes
3. Watch the **All Heap & Anonymous VM** allocation graph

**Pass criteria**:
- Memory usage plateaus after the first ~30 seconds (object pool stabilises)
- No continuous upward trend in allocations
- No leaks reported by the Leaks instrument

---

## Test 3: Input Latency (Manual)

### Steps
1. Run the game in Release configuration (**Product → Scheme → Edit Scheme → Run → Release**)
2. Press Space rapidly during gameplay
3. Observe Ghosty's response

**Pass criteria**: Ghosty visibly responds to each Space press within the same frame — no perceptible lag between keypress and jump.

---

## Test 4: High-Score Stress (Speed Cap Verification)

### Steps
1. Modify `DifficultyConstants.baseSpeed` temporarily to `400` to start at high speed
2. Run the game and play for 2 minutes
3. Verify frame rate remains stable at high scroll speed

**Pass criteria**: 60 FPS maintained even at `maxSpeed` (520 pt/s).

**Revert** `baseSpeed` to `220` after testing.

---

## Notes

- No load testing tools (JMeter, k6) are applicable — this is a local single-user desktop game
- No network latency to measure
- Performance testing is entirely via Xcode Instruments
