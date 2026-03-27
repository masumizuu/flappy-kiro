# Flappy Kiro - Requirement Verification Questions

Please answer each question by filling in the letter choice after the `[Answer]:` tag.
If none of the options match, choose the last option (Other) and describe your preference.
Let me know when you're done.

---

## Question 1
What platform should Flappy Kiro target?

A) Web browser (HTML5/JavaScript — playable in browser, no install needed)
B) Desktop application (native app for Windows/macOS/Linux)
C) Mobile (iOS and/or Android)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
B) Desktop application (native app for Windows/macOS/Linux)
---

## Question 2
Which technology stack do you prefer for building the game?

A) Plain HTML5 Canvas + JavaScript (no framework, minimal dependencies)
B) Python with Pygame
C) A JavaScript game framework (e.g., Phaser)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
D) Other - Typescript? Swift? Whatever the language used for macOS app development. I want to explore making macOS desktop apps.
---

## Question 3
Should the game use the provided assets in the `assets/` folder (ghosty.png sprite, jump.wav and game_over.wav audio files)?

A) Yes — use all provided assets (sprite + audio)
B) Yes — use the sprite only, no audio
C) No — generate/draw everything programmatically (no external assets)
D) Other (please describe after [Answer]: tag below)

[Answer]: 
C) No - please generate / draw everything programmatically. The style I want is cutesy / whimsical. You may use the catpuccino color scheme. The font you may use from Google Fonts - Sora for Headings and JetBrains Mono for body texts.
---

## Question 4
What should happen when the game ends (collision with wall or ground)?

A) Show a "Game Over" screen with the final score and a restart option
B) Immediately restart the game
C) Show a "Game Over" screen with final score, high score, and a restart option
D) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Show a "Game Over" screen with the final score and a restart option. 
---

## Question 5
Should the game difficulty increase over time (e.g., walls move faster as score increases)?

A) Yes — gradually increase speed as the score goes up
B) No — keep a constant speed throughout
C) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Yes - gradually increase speed as the score goes up.
---

## Question 6
Should security extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade applications)
B) No — skip all SECURITY rules (suitable for PoCs, prototypes, and experimental projects)
C) Other (please describe after [Answer]: tag below)

[Answer]: 
A) Yes - enforce all SECURITY rules as blocking constraints, but if there's an error use something like "console.error()" so I can easily debug. I will disable it manually later after I am done deploying the project.
