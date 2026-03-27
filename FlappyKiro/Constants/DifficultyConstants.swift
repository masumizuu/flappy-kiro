/// DifficultyConstants.swift
/// Flappy Kiro
///
/// Controls how fast the game gets harder as the player scores points.
///
/// Speed formula: currentSpeed = min(baseSpeed + score × speedIncrement, maxSpeed)
///
/// Example progression:
///   Score  0 → 220 pt/s
///   Score  5 → 260 pt/s
///   Score 10 → 300 pt/s
///   Score 37 → 516 pt/s (effectively capped at 520)

import CoreGraphics

enum DifficultyConstants {

    /// Starting scroll speed at score 0.
    /// Set high enough to be immediately engaging — not too slow or boring.
    static let baseSpeed: CGFloat = 220

    /// Speed added per point scored.
    static let speedIncrement: CGFloat = 8

    /// Maximum scroll speed regardless of score.
    static let maxSpeed: CGFloat = 520
}
