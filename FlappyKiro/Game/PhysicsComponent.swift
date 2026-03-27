/// PhysicsComponent.swift
/// Flappy Kiro
///
/// Manages Ghosty's vertical motion: gravity, jump impulse, and boundary clamping.
///
/// How it works:
///   Every frame, gravity pulls `velocity` downward.
///   When the player presses Space, `applyJump()` sets velocity to a fixed upward value.
///   `update(deltaTime:)` integrates velocity into position each frame.
///   Boundary checks prevent Ghosty from leaving the scene vertically.

import SpriteKit

final class PhysicsComponent {

    // MARK: - State

    /// Ghosty's SpriteKit node — position is read and written here each frame.
    private weak var ghostyNode: SKShapeNode?

    /// Current vertical velocity in points per second.
    /// Positive = moving up, negative = moving down.
    private var velocity: CGFloat = 0

    // MARK: - Init

    /// - Parameter ghostyNode: The SKShapeNode that represents Ghosty in the scene.
    init(ghostyNode: SKShapeNode) {
        self.ghostyNode = ghostyNode
    }

    // MARK: - Public API

    /// Resets Ghosty to the starting position and zeroes velocity.
    /// Called at the beginning of each new game.
    func reset() {
        velocity = 0
        ghostyNode?.position = CGPoint(
            x: LayoutConstants.ghostyStartX,
            y: LayoutConstants.ghostyStartY
        )
    }

    /// Applies an upward velocity impulse — called when the player presses Space.
    /// This sets (not adds to) the velocity so every jump feels consistent.
    func applyJump() {
        velocity = PhysicsConstants.jumpVelocity
    }

    /// Updates Ghosty's position for one frame.
    ///
    /// - Parameter deltaTime: Time elapsed since the last frame (seconds).
    ///   Should already be clamped to `PhysicsConstants.maxDeltaTime` by the caller.
    func update(deltaTime: CGFloat) {
        guard let node = ghostyNode else { return }

        // Apply gravity: velocity decreases (becomes more negative) each frame.
        velocity += PhysicsConstants.gravity * deltaTime

        // Clamp to terminal velocity so Ghosty doesn't fall infinitely fast.
        velocity = max(velocity, PhysicsConstants.terminalVelocity)

        // Integrate velocity into position.
        node.position.y += velocity * deltaTime

        // --- Boundary clamping ---

        let halfH = LayoutConstants.ghostySize.height / 2
        let sceneH = LayoutConstants.sceneSize.height

        // Ceiling: stop Ghosty at the top of the scene.
        if node.position.y + halfH >= sceneH {
            node.position.y = sceneH - halfH
            velocity = 0
        }
        // Ground: collision is handled by CollisionHandler via physics bodies,
        // but we also clamp here as a safety net.
        let groundTop = LayoutConstants.groundHeight
        if node.position.y - halfH <= groundTop {
            node.position.y = groundTop + halfH
        }
    }

    /// Returns Ghosty's current bounding rectangle in scene coordinates.
    /// Used by ScoreComponent to detect wall passthrough.
    func ghostyFrame() -> CGRect {
        guard let node = ghostyNode else { return .zero }
        let size = LayoutConstants.ghostySize
        return CGRect(
            x: node.position.x - size.width  / 2,
            y: node.position.y - size.height / 2,
            width:  size.width,
            height: size.height
        )
    }

    /// Current velocity — exposed so RenderComponent can tilt Ghosty based on movement.
    var currentVelocity: CGFloat { velocity }
}
