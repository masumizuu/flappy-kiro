/// PhysicsConstants.swift
/// Flappy Kiro
///
/// Defines all numeric constants that control Ghosty's movement physics.
/// Tweak these values to change how the game feels without touching game logic.
///
/// Units: points per second (pt/s) for velocities, pt/s² for acceleration.

import CoreGraphics

enum PhysicsConstants {

    /// Downward acceleration applied to Ghosty every second.
    /// Higher magnitude = faster fall. Classic Flappy Bird uses ~1800.
    static let gravity: CGFloat = -1800

    /// Upward velocity instantly applied when the player presses Space.
    /// This overrides (not adds to) the current velocity, giving a consistent jump height.
    static let jumpVelocity: CGFloat = 620

    /// Maximum downward speed Ghosty can reach.
    /// Prevents uncontrollable free-fall at high fall distances.
    static let terminalVelocity: CGFloat = -900

    /// Maximum deltaTime passed to physics each frame (seconds).
    /// Clamps the first frame and any stutter frames to prevent physics tunnelling.
    static let maxDeltaTime: CGFloat = 1.0 / 30.0
}
