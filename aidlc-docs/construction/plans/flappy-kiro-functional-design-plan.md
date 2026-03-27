# Functional Design Plan - Flappy Kiro

## Plan Checkboxes

- [x] Answer clarifying questions
- [x] Generate domain-entities.md
- [x] Generate business-logic-model.md
- [x] Generate business-rules.md
- [x] Generate frontend-components.md

---

## Clarifying Questions

Please fill in the `[Answer]:` tags below, then let me know when done.

---

### Question 1: Physics Feel
What should Ghosty's jump feel like?

A) Snappy — quick burst upward, falls fast (arcade-tight, punishing)
B) Floaty — slow rise, slow fall (more forgiving, casual)
C) Balanced — moderate rise and fall speed (classic Flappy Bird feel)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
C) Balanced
---

### Question 2: Wall Gap Size
How large should the gap between the top and bottom walls be?

A) Tight — just slightly larger than Ghosty (challenging)
B) Comfortable — about 3× Ghosty's height (moderate)
C) Generous — about 4–5× Ghosty's height (beginner-friendly)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
D) Other - Dynamic gaps. Some are bigger, some are smaller - but it should always be possible to go through. 
---

### Question 3: Difficulty Curve
How should speed increase with score?

A) Linear — constant speed increase per point (predictable, steady ramp)
B) Stepped — speed jumps at score milestones (e.g., every 5 points)
C) Exponential — slow at first, then ramps up sharply at higher scores
D) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Linear but even in the first stages of the game, it shouldn't be too slow / boring.
---

### Question 4: Score Display Position
Where should the live score be shown during gameplay?

A) Top-centre of the screen
B) Top-left corner
C) Top-right corner
D) Other (please describe after [Answer]: tag below)

[Answer]: 
B) Top-left corner
---

### Question 5: Ghosty's Shape
Since everything is drawn programmatically, what should Ghosty look like?

A) Simple rounded ghost — oval body with two small eyes (classic ghost silhouette)
B) Circle with a cute face — round with dot eyes and a small smile
C) Other (please describe after [Answer]: tag below)

[Answer]: 
C) Other - Ghost but cutesy and the typical tail with the you know, it slims down towards the tail, with two cute hands reach out. Face should be "O w O"