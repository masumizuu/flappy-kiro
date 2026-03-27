/// ScoreComponent.swift
/// Flappy Kiro
///
/// Tracks the player's score and detects when Ghosty passes through a wall gap.
///
/// Passthrough detection:
///   A wall pair is "passed" when Ghosty's X position moves past the wall's right edge
///   AND the pair hasn't been counted yet (`passed == false`).
///   The `passed` flag is set immediately to prevent double-counting.

import CoreGraphics

final class ScoreComponent {

    // MARK: - State

    private(set) var currentScore: Int = 0

    // MARK: - Public API

    /// Resets the score to zero. Called at the start of each new game.
    func reset() {
        currentScore = 0
    }

    /// Checks whether Ghosty has passed through any uncounted wall pairs and
    /// increments the score accordingly.
    ///
    /// - Parameters:
    ///   - ghostyX: Ghosty's current X position in scene coordinates.
    ///   - walls: The active wall pairs managed by WallSpawner.
    func checkPassthrough(ghostyX: CGFloat, walls: [WallPair]) {
        for wall in walls {
            guard !wall.passed else { continue }

            // The right edge of the wall pair's centre column.
            let wallRightEdge = wall.xPosition + LayoutConstants.wallWidth / 2

            if ghostyX > wallRightEdge {
                wall.passed = true
                currentScore += 1
            }
        }
    }
}
