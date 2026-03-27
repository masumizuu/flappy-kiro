/// DifficultyComponent.swift
/// Flappy Kiro
///
/// Computes the current wall scroll speed from the player's score.
///
/// Speed formula:
///   currentSpeed = min(baseSpeed + score × speedIncrement, maxSpeed)
///
/// The base speed is set high enough that the game is engaging from the very first wall.
/// Speed increases linearly — predictable and fair for the player.

import CoreGraphics

final class DifficultyComponent {

    // MARK: - Public API

    /// Resets difficulty to its initial state.
    /// (No stored state needed — speed is always computed from score.)
    func reset() {
        // Nothing to reset: speed is a pure function of score.
    }

    /// Returns the scroll speed (points per second) for the given score.
    ///
    /// - Parameter score: The player's current score.
    /// - Returns: Wall scroll speed in pt/s, capped at `DifficultyConstants.maxSpeed`.
    func currentSpeed(for score: Int) -> CGFloat {
        let speed = DifficultyConstants.baseSpeed
                  + CGFloat(score) * DifficultyConstants.speedIncrement
        return min(speed, DifficultyConstants.maxSpeed)
    }
}
