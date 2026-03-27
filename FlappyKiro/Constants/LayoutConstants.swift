/// LayoutConstants.swift
/// Flappy Kiro
///
/// Defines the fixed internal coordinate space and all spatial measurements.
/// The game always renders at `sceneSize` internally; the window scales around it.

import CoreGraphics

enum LayoutConstants {

    // MARK: - Scene

    /// Fixed internal scene dimensions. All game logic uses these coordinates.
    /// The window letterboxes/pillarboxes around this size on resize.
    static let sceneSize = CGSize(width: 400, height: 600)

    // MARK: - Ground

    /// Height of the ground bar at the bottom of the scene.
    static let groundHeight: CGFloat = 60

    // MARK: - Ghosty

    /// Bounding box of Ghosty's body (used for physics body sizing and rendering).
    static let ghostySize = CGSize(width: 36, height: 40)

    /// Ghosty's fixed horizontal position — stays constant throughout gameplay.
    static let ghostyStartX: CGFloat = 100

    /// Ghosty's starting vertical centre position at game start.
    static let ghostyStartY: CGFloat = 300

    // MARK: - Walls

    /// Width of each wall segment (top and bottom).
    static let wallWidth: CGFloat = 52

    /// Corner radius for wall rounded rectangles.
    static let wallCornerRadius: CGFloat = 6

    /// X position where new wall pairs spawn — just off the right edge of the scene.
    static let wallSpawnX: CGFloat = 460

    /// Base time interval between wall pair spawns (seconds).
    /// Decreases with score; see WallSpawner for the formula.
    static let baseSpawnInterval: TimeInterval = 1.6

    /// Minimum spawn interval regardless of score (prevents walls from overlapping).
    static let minSpawnInterval: TimeInterval = 0.8

    // MARK: - Gap

    /// Minimum gap height as a multiple of Ghosty's height.
    /// Ensures the gap is always passable.
    static let minGapMultiplier: CGFloat = 2.8

    /// Maximum gap height as a multiple of Ghosty's height.
    static let maxGapMultiplier: CGFloat = 4.5

    /// Vertical padding from scene edges when placing the gap centre.
    static let gapEdgePadding: CGFloat = 20

    // MARK: - Window

    /// Minimum window size enforced by the app shell.
    static let minimumWindowSize = CGSize(width: 400, height: 600)
}
