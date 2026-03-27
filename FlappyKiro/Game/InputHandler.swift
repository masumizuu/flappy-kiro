/// InputHandler.swift
/// Flappy Kiro
///
/// Captures macOS keyboard events and routes them to the correct game action.
///
/// Security note (SECURITY-05):
///   Only the Spacebar (keyCode 49 / kVK_Space) is accepted.
///   All other key codes are silently discarded — this is an explicit allowlist,
///   not a blocklist. No user input is stored or logged.

import Carbon   // for kVK_Space constant

final class InputHandler {

    // MARK: - Dependencies

    /// Called when the player should jump (Space pressed during gameplay).
    var onJump: (() -> Void)?

    /// Called when the player wants to start a new game (Space on idle/game-over screen).
    var onStart: (() -> Void)?

    // MARK: - Public API

    /// Routes a key-down event to the appropriate action based on the current game state.
    ///
    /// - Parameters:
    ///   - keyCode: The hardware key code from the NSEvent.
    ///   - gameState: The current state of the game.
    func handleKeyDown(keyCode: UInt16, gameState: GameState) {
        // Allowlist: only Spacebar triggers any action.
        guard keyCode == UInt16(kVK_Space) else { return }

        switch gameState {
        case .idle:
            onStart?()
        case .playing:
            onJump?()
        case .gameOver:
            onStart?()
        }
    }
}
