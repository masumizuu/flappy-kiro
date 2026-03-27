/// GameState.swift
/// Flappy Kiro
///
/// Defines the three possible states of the game.
/// GameScene uses this enum to decide what to update and render each frame.

/// The game's state machine has exactly three states:
///
///   idle ──(Space)──▶ playing ──(collision)──▶ gameOver
///                        ▲                          │
///                        └──────────(Space)──────────┘
enum GameState {
    /// The start screen is visible. Waiting for the player to press Space.
    case idle

    /// Active gameplay. The game loop runs, walls scroll, physics update.
    case playing

    /// A collision occurred. The Game Over screen is visible.
    /// Pressing Space resets everything and returns to `playing`.
    case gameOver
}
