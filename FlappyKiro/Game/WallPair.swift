/// WallPair.swift
/// Flappy Kiro
///
/// Represents a single pair of walls (one on top, one on bottom) with a gap between them.
/// WallSpawner creates and recycles these; CollisionHandler detects contacts with them.

import SpriteKit

/// A wall pair consists of two SKShapeNode walls and metadata used by the game logic.
///
/// The `passed` flag prevents the score from incrementing more than once per pair —
/// once Ghosty's X position clears the wall's right edge, `passed` is set to true.
final class WallPair {

    // MARK: - Nodes

    /// The wall segment hanging down from the top of the scene.
    let topWall: SKShapeNode

    /// The wall segment rising up from above the ground.
    let bottomWall: SKShapeNode

    // MARK: - Metadata

    /// Unique identifier — used to match this pair when checking passthrough.
    let id: UUID

    /// Y-coordinate of the centre of the gap between the two walls.
    var gapCentreY: CGFloat = 0

    /// Height of the gap. Randomised per pair within the safe range defined in LayoutConstants.
    var gapHeight: CGFloat = 0

    /// Whether Ghosty has already passed through this pair.
    /// Set to true the first time passthrough is detected to prevent double-scoring.
    var passed: Bool = false

    // MARK: - Init

    init() {
        id = UUID()
        topWall    = SKShapeNode()
        bottomWall = SKShapeNode()
    }

    // MARK: - Helpers

    /// The current X position of this wall pair (both walls share the same X).
    var xPosition: CGFloat {
        get { topWall.position.x }
        set {
            topWall.position.x    = newValue
            bottomWall.position.x = newValue
        }
    }

    /// Removes both wall nodes from their parent scene node.
    func removeFromParent() {
        topWall.removeFromParent()
        bottomWall.removeFromParent()
    }

    /// Resets mutable state so this pair can be reused from the object pool.
    func reset() {
        passed      = false
        gapCentreY  = 0
        gapHeight   = 0
    }
}
