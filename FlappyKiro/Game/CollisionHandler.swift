/// CollisionHandler.swift
/// Flappy Kiro
///
/// Detects physics contacts between Ghosty and walls or the ground,
/// then notifies GameScene to trigger the game-over transition.
///
/// How SpriteKit physics contacts work:
///   Each node has a `physicsBody` with a `categoryBitMask`.
///   When two bodies touch, SpriteKit calls `didBegin(_:)` on the scene's
///   `physicsContactDelegate` — that's this class.
///   We check the category masks to confirm it's a relevant collision.

import SpriteKit

// MARK: - Physics Category Bitmasks

/// Bitmasks identify which type of object a physics body belongs to.
/// Each value must be a unique power of 2 so they can be combined with bitwise OR.
enum PhysicsCategory {
    static let none:   UInt32 = 0
    static let ghosty: UInt32 = 0b0001   // 1
    static let wall:   UInt32 = 0b0010   // 2
    static let ground: UInt32 = 0b0100   // 4
}

// MARK: - CollisionHandler

final class CollisionHandler: NSObject, SKPhysicsContactDelegate {

    // MARK: - Dependencies

    /// Weak reference to GameScene so we can trigger game over without a retain cycle.
    private weak var gameScene: GameScene?

    // MARK: - Init

    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }

    // MARK: - SKPhysicsContactDelegate

    /// Called by SpriteKit when two physics bodies first make contact.
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        let combined = maskA | maskB

        // Ghosty hit a wall or the ground → game over.
        let ghostyHitWall   = combined == (PhysicsCategory.ghosty | PhysicsCategory.wall)
        let ghostyHitGround = combined == (PhysicsCategory.ghosty | PhysicsCategory.ground)

        if ghostyHitWall || ghostyHitGround {
            // Dispatch to the main thread — SpriteKit contact callbacks can arrive
            // on a background thread, but scene mutations must happen on main.
            DispatchQueue.main.async { [weak self] in
                self?.gameScene?.triggerGameOver()
            }
        }
    }
}
